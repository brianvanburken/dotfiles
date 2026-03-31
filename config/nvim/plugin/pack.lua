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
    local height = plugin_count + 5
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
        table.sort(results, function(a, b) return a.name < b.name end)

        local lines = {}
        for _, r in ipairs(results) do
            local is_outdated = r.latest ~= nil and r.current ~= r.latest
            if is_outdated then
                table.insert(lines, string.format(" * %-26s %s -> %s", r.name, r.current:sub(1, 12), r.latest:sub(1, 12)))
            elseif r.latest == nil then
                table.insert(lines, string.format("   %-26s fetch error", r.name))
            else
                table.insert(lines, string.format("   %-26s up to date", r.name))
            end
        end

        table.insert(lines, "")
        if #results < plugin_count then
            table.insert(lines, string.format("   Checking... (%d/%d)", #results, plugin_count))
            table.insert(lines, "")
        end
        table.insert(lines, "   u: update plugin under cursor   q: close")

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
    end

    local function update_plugin(r)
        if r.latest == nil or r.current == r.latest then return end
        local plugin_dir = vim.fs.joinpath(config_path, "plugin")
        for fname, _ in vim.fs.dir(plugin_dir) do
            local fpath = vim.fs.joinpath(plugin_dir, fname)
            local file_lines = vim.fn.readfile(fpath)
            local content = table.concat(file_lines, "\n")
            if content:find(r.src, 1, true) then
                local new_content = content:gsub('rev = "[0-9a-f]+"', 'rev = "' .. r.latest .. '"')
                vim.fn.writefile(vim.split(new_content, "\n"), fpath)
                r.current = r.latest
                vim.notify(r.name .. " pinned to " .. r.latest:sub(1, 12) .. " — run :PackUpdate to apply")
                render()
                return
            end
        end
        vim.notify("Could not find plugin file for " .. r.name, vim.log.levels.WARN)
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "   Fetching latest commits..." })
    vim.bo[buf].modifiable = false

    for name, info in pairs(lock.plugins) do
        vim.system(
            { "git", "ls-remote", "--exit-code", info.src, "HEAD" },
            { text = true },
            function(res)
                local entry = { name = name, current = info.rev, src = info.src }
                if res.code == 0 then
                    entry.latest = res.stdout:match("^(%x+)")
                end
                table.insert(results, entry)
                schedule_render()
            end
        )
    end

    vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
    vim.keymap.set("n", "u", function()
        local row = vim.api.nvim_win_get_cursor(win)[1]
        local r = results[row]
        if r then update_plugin(r) end
    end, { buffer = buf })
end, { desc = "Check for plugin updates" })
