vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
end, { desc = "Updates all vim pack plugins" })

vim.api.nvim_create_user_command("PackOutdated", function()
    local config_path = vim.fn.stdpath("config")
    local lock_path = vim.fs.joinpath(config_path, "nvim-pack-lock.json")
    local ok, lock_raw = pcall(vim.fn.readfile, lock_path)
    if not ok then
        vim.notify("Could not read nvim-pack-lock.json", vim.log.levels.ERROR)
        return
    end
    local lock = vim.json.decode(table.concat(lock_raw, "\n"))

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"

    local width = 62
    local plugin_count = vim.tbl_count(lock.plugins)
    local height = plugin_count + 3
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " PackOutdated ",
        title_pos = "center",
    })

    local results = {}
    local render_pending = false
    local render

    local function schedule_render()
        if not render_pending then
            render_pending = true
            vim.schedule(function()
                render_pending = false
                render()
            end)
        end
    end

    render = function()
        local lines = {}
        for _, r in ipairs(results) do
            if r.fetching then
                table.insert(lines, string.format("   %-26s fetching...", r.name))
            else
                local is_outdated = r.latest ~= nil and r.current ~= r.latest
                if is_outdated then
                    table.insert(lines,
                        string.format(" * %-26s %s -> %s", r.name, r.current:sub(1, 12), r.latest:sub(1, 12)))
                elseif r.latest == nil then
                    table.insert(lines, string.format("   %-26s fetch error", r.name))
                else
                    table.insert(lines, string.format("   %-26s up to date", r.name))
                end
            end
        end

        table.insert(lines, "")
        table.insert(lines, "   u: update   gx: open repo   q: close")

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
    end

    local src_to_file = {}

    local function update_plugin(r)
        if r.latest == nil or r.current == r.latest then return end
        local cached = src_to_file[r.src]
        if not cached then
            vim.notify("Could not find plugin file for " .. r.name, vim.log.levels.WARN)
            return
        end
        local new_content = cached.content:gsub('rev = "[0-9a-f]+"', 'rev = "' .. r.latest .. '"')
        vim.fn.writefile(vim.split(new_content, "\n"), cached.path)
        cached.content = new_content
        r.current = r.latest
        vim.notify(r.name .. " pinned to " .. r.latest:sub(1, 12) .. " — run :PackUpdate to apply")
        render()
    end

    local names = vim.tbl_keys(lock.plugins)
    table.sort(names)
    for _, name in ipairs(names) do
        local info = lock.plugins[name]
        table.insert(results, { name = name, current = info.rev, src = info.src, fetching = true })
    end
    render()

    local plugin_dir = vim.fs.joinpath(config_path, "plugin")
    for fname, _ in vim.fs.dir(plugin_dir) do
        local fpath = vim.fs.joinpath(plugin_dir, fname)
        local content = table.concat(vim.fn.readfile(fpath), "\n")
        for _, entry in ipairs(results) do
            if content:find(entry.src, 1, true) then
                src_to_file[entry.src] = { path = fpath, content = content }
            end
        end
    end

    for _, entry in ipairs(results) do
        vim.system(
            { "git", "ls-remote", "--exit-code", entry.src, "HEAD" },
            { text = true },
            function(res)
                entry.fetching = false
                if res.code == 0 then
                    entry.latest = res.stdout:match("^(%x+)")
                end
                schedule_render()
            end
        )
    end

    local close = function() vim.api.nvim_win_close(win, true) end
    vim.keymap.set("n", "q", close, { buffer = buf })
    vim.keymap.set("n", "<Esc>", close, { buffer = buf })
    vim.keymap.set("n", "u", function()
        local row = vim.api.nvim_win_get_cursor(win)[1]
        local r = results[row]
        if r then update_plugin(r) end
    end, { buffer = buf })
    vim.keymap.set("n", "gx", function()
        local row = vim.api.nvim_win_get_cursor(win)[1]
        local r = results[row]
        if not r then return end
        local url = r.src:gsub("^git@([^:]+):", "https://%1/"):gsub("%.git$", "")
        vim.ui.open(url)
    end, { buffer = buf })
end, { desc = "Check for plugin updates" })
