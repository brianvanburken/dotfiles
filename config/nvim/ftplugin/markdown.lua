vim.o.wrap         = false
vim.o.linebreak    = true
vim.o.conceallevel = 0

-- Color markdown urls as conceal to make them less prominent
vim.api.nvim_set_hl(0, 'markdownUrl', { link = 'Conceal' })

-- Below is my code to make Wiki links working within an obsidian vault
-- without usage of dependencies.
--
local api   = vim.api
local fn    = vim.fn
local vault = "/Volumes/Personal Data"

-- Extracts the name between the square brackets under the cursor
-- [[Name]] => Name
local function get_link()
    local line  = api.nvim_get_current_line()
    local col   = fn.col(".")
    local start = line:sub(1, col):match(".*()%[%[") -- last "[[" before cursor
    if not start then return end
    local finish = line:find("]]", start)
    if not finish then return end
    return line:sub(start + 2, finish - 1)
end

-- Follow the file under the cursor by searching within the vault
local function follow()
    local name = get_link()
    if not name then
        vim.notify("No [[Link]] under cursor", vim.log.levels.WARN)
        return
    end

    -- search for any matching then ame in vault (recursive)
    local pattern = "**/" .. name .. ".md"
    local raw = vim.fn.globpath(vault, pattern, false, true)
    local matches = (type(raw) == "table" and raw) or {}

    if #matches == 0 then
        vim.notify("No file found for \"" .. name .. "\"", vim.log.levels.WARN)
        return
    end

    local first_match = matches[1]
    api.nvim_command("edit " .. fn.fnameescape(first_match))
end

-- If the current buffer is within our vault we will set the gf mapping
local buf = api.nvim_buf_get_name(0)
if buf:match("^" .. vim.pesc(vault)) then
    api.nvim_buf_set_keymap(0, "n", "gf", "", { callback = follow, silent = true })
end
