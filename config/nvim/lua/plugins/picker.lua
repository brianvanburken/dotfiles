-- Only keep alphabetic marks (user-set)
-- User marks are 'a to 'z and 'A to 'Z
local function is_user_mark(m)
    local s = m.mark
    -- 39 = "'"
    if type(s) ~= "string" or #s < 2 or s:byte(1) ~= 39 then return false end
    local c = s:byte(2)
    -- A-Z or a-z
    return (c >= 65 and c <= 90) or (c >= 97 and c <= 122)
end

--- Prepare a line for display in the picker.
--- - Removes leading whitespace
--- - Clips to 160 characters, appends "…" if clipped
---
--- @param s string|nil
--- @return string
local function prepare_line(s)
    s = s or ""
    -- strip leading spaces/tabs
    s = s:gsub("^%s+", "")
    -- clip long lines
    if #s > 160 then
        s = s:sub(1, 160) .. "…"
    end
    return s
end

--- Ensure file lines are cached and pre-processed
local function ensure_cached(file, cache)
    if cache[file] ~= nil then return end
    local ok, lines = pcall(vim.fn.readfile, file)
    if not ok or not lines then
        cache[file] = false
        return
    end
    for i, line in ipairs(lines) do
        lines[i] = prepare_line(line)
    end
    cache[file] = lines
end

--- Get the line text at (buf,file,lnum). Uses live buffer if loaded,
--- else reads from disk once per file (cached for this run).
--- The returned string is trimmed, tabs softened, and clipped.
--- @param buf integer
--- @param file string
--- @param lnum integer 1-based
--- @param cache table<string, string[]>
--- @return string
local function line_snippet(buf, file, lnum, cache)
    if buf and vim.api.nvim_buf_is_loaded(buf) then
        return prepare_line(
            vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
        )
    elseif file ~= "" then
        ensure_cached(file, cache)
        local lines = cache[file]
        return (lines and lines[lnum]) or ""
    end
    return ""
end

--- Build a list of Neovim marks as items for `mini.pick`
--- Each item includes display text and navigation info.
---
--- Global marks (`vim.fn.getmarklist()`) and buffer-local marks
--- (`vim.fn.getmarklist(0)`) are collected.
--- @return table[] items for `mini.pick` source
local function mark_items()
    local items, cache = {}, {}

    local function add_mark(m)
        if not is_user_mark(m) then return end
        local buf, lnum, col = m.pos[1], m.pos[2], m.pos[3]
        if not lnum or lnum <= 0 then return end

        local file  = (m.file ~= "" and m.file) or vim.api.nvim_buf_get_name(buf)

        local rel   = vim.fn.fnamemodify(file, ":.")
        local code  = line_snippet(buf, file, lnum, cache)
        local label = m.mark .. "  " .. rel .. ":" .. lnum
        if code ~= "" then label = label .. "  │ " .. code end

        items[#items + 1] = {
            text = label,
            file = file,
            buf  = buf,
            lnum = lnum,
            col  = col,
        }
    end

    for _, m in ipairs(vim.fn.getmarklist()) do add_mark(m) end
    for _, m in ipairs(vim.fn.getmarklist(0)) do add_mark(m) end

    table.sort(items, function(a, b) return a.text < b.text end)
    return items
end

--- Jump to the location of a selected mark item.
--- This runs after the picker closes (via `vim.schedule`).
---
--- @param item table A mark item from `mark_items()`:
--- @param target_win integer The window ID where the jump should occur
local function choose_mark(item, target_win)
    local lnum = item.lnum
    local col  = math.max((item.col or 1) - 1, 0)

    vim.schedule(function()
        -- Focus the original window
        vim.api.nvim_set_current_win(target_win)

        -- Open file or buffer
        if item.file ~= "" then
            vim.fn.bufadd(item.file)
            vim.cmd("keepjumps edit " .. vim.fn.fnameescape(item.file))
        elseif item.buf and item.buf > 0 then
            vim.cmd("keepjumps buffer " .. item.buf)
        end

        -- Move cursor to saved position
        pcall(vim.api.nvim_win_set_cursor, target_win, { lnum, col })
    end)
end

return {
    'echasnovski/mini.pick',
    keys = {
        { '<leader>ff', '<cmd>Pick files<cr>',              desc = 'Search files' },
        { '<leader>fg', '<cmd>Pick grep_live<cr>',          desc = 'Search buffers' },
        { '<leader>ft', '<cmd>Pick grep_todo_keywords<cr>', desc = 'Search todo/fixme/note' },
        { '<leader>fr', '<cmd>Pick resume<cr>',             desc = 'Resume previous search' },
        { '<leader>fm', '<cmd>Pick marks<cr>',              desc = 'Pick marks' },
    },
    opts = function()
        local MiniPick = require("mini.pick")

        MiniPick.registry.marks = function()
            local target_win = vim.api.nvim_get_current_win()
            MiniPick.start({
                source = {
                    name   = "Marks",
                    items  = mark_items,
                    choose = function(item) choose_mark(item, target_win) end,
                },
            })
        end

        MiniPick.registry.grep_todo_keywords = function(opts)
            opts.pattern = "(TODO|FIXME|NOTE)"
            MiniPick.builtin.grep(opts, {})
        end

        return {
            source = {
                show = MiniPick.default_show
            },
            options = {
                use_cache           = true,
                content_from_bottom = true,
            },
            window = {
                config = {
                    -- use entire editor width
                    width = vim.o.columns,
                    -- start at left edge
                    col = 0,
                },
            },
        }
    end,
}
