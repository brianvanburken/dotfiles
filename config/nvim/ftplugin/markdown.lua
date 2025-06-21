vim.o.wrap         = false
vim.o.linebreak    = true
vim.o.conceallevel = 0

-- Color markdown urls as conceal to make them less prominent
vim.api.nvim_set_hl(0, 'markdownUrl', { link = 'Conceal' })

-- Below is my code to make Wiki links working within an obsidian vault
-- without usage of dependencies.
local api   = vim.api
local fn    = vim.fn
local vault = "/Volumes/Personal Data"

-- Extracts the name between the square brackets under the cursor
-- [[Name]] => Name
local function get_link()
    local line  = api.nvim_get_current_line() -- current line
    local col   = fn.col('.')                 -- byte index of cursor

    -- find the last "[[" before or at the cursor
    local start = line:sub(1, col):match('.*()%[%[')
    if not start then return nil end

    -- find the corresponding "]]" after that
    local finish = line:find(']]', start + 2, true)
    if not finish then return nil end

    -- only return if cursor is actually inside the brackets
    if col < (start + 2) or col > finish then
        return nil
    end

    return line:sub(start + 2, finish - 1)
end

local function follow()
    local name = get_link()
    if not name then
        vim.notify("No [[Link]] under cursor", vim.log.levels.WARN)
        return
    end

    local results = vim.fs.find(name .. ".md", {
        path  = vault,
        type  = "file",
        limit = 1,
    })
    if results[1] then
        api.nvim_command("edit " .. fn.fnameescape(results[1]))
        return
    end

    vim.notify("No file found for \"" .. name .. "\"", vim.log.levels.WARN)
end


-- If the current buffer is within our vault we will set the gf mapping
local buf = api.nvim_buf_get_name(0)
if buf:match("^" .. vim.pesc(vault)) then
    api.nvim_buf_set_keymap(0, "n", "gf", "", { callback = follow, silent = true })
end
