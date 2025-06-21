vim.o.wrap         = false
vim.o.linebreak    = true
vim.o.conceallevel = 0

-- Color markdown urls as conceal to make them less prominent
vim.api.nvim_set_hl(0, 'markdownUrl', { link = 'Conceal' })

--------------------------------------------------------------------------------
-- wiki links plugin
--
-- A small Neovim plugin to navigate Obsidian-style [[Wiki Links]] within a vault.
-- Press `gf` on a link to jump to the corresponding .md file in the defined vault.
--------------------------------------------------------------------------------

local api   = vim.api
local fn    = vim.fn
local vault = "/Volumes/Personal Data" -- Base path to Obsidian vault

--------------------------------------------------------------------------------
--- Extracts the link target under (or before) the cursor in the form [[Name]].
---
--- It finds the last "[[" before the cursor and the matching "]]" after,
--- returning the inner text if the cursor lies between them.
---
--- @return string|nil  The target name (without brackets), or nil if none found.
local function get_link()
    -- Get the current line and cursor byte position
    local line  = api.nvim_get_current_line()
    local col   = fn.col('.')

    -- Find the last "[[" before or at the cursor
    local start = line:sub(1, col):match('.*()%[%[')
    if not start then
        return nil
    end

    -- Find the closing "]]" after the opening
    local finish = line:find(']]', start + 2, true)
    if not finish then
        return nil
    end

    -- Ensure cursor is actually inside the link brackets
    if col < (start + 2) or col > finish then
        return nil
    end

    -- Extract and return the link text
    return line:sub(start + 2, finish - 1)
end

--------------------------------------------------------------------------------
--- Follow the [[Wiki Link]] under the cursor by opening the corresponding .md file.
---
--- It uses Neovim's built-in `vim.fn.findfile()` first (fast, stops at first match),
--- then falls back to pure-Lua `vim.fs.find()` if needed.
---
local function follow()
    -- Get the base name from the link syntax
    local name = get_link()
    if not name then
        vim.notify("No [[Link]] under cursor", vim.log.levels.WARN)
        return
    end

    -- 1) Try Vim's findfile (lazy glob, stops at first match)
    local file = fn.findfile(name .. ".md", vault .. "/**", true)
    if file ~= "" then
        api.nvim_command("edit " .. fn.fnameescape(file))
        return
    end

    -- 2) Fallback to pure Lua find (also stops at first match)
    local results = vim.fs.find(name .. ".md", {
        path  = vault,
        type  = "file",
        limit = 1,
    })
    if results[1] then
        api.nvim_command("edit " .. fn.fnameescape(results[1]))
        return
    end

    -- Notify if no file was found
    vim.notify("No file found for \"" .. name .. "\"", vim.log.levels.WARN)
end

--------------------------------------------------------------------------------
-- Set up the `gf` mapping in any buffer inside the vault path
-- so you can jump to links only when editing your vault files.
--------------------------------------------------------------------------------
local buf = api.nvim_buf_get_name(0)
if buf:match("^" .. vim.pesc(vault)) then
    api.nvim_buf_set_keymap(0, "n", "gf", "", {
        callback = follow,
        silent   = true,
        desc     = "Follow Obsidian [[Wiki Links]] in vault"
    })
end

-- End of wiki_links.lua
