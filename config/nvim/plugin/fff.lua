vim.g.fff = {
    lazy_sync = true,
    prompt = "",
    title = "Files",
    layout = {
        prompt_position = "top",
        preview_position = "bottom",
        flex = { wrap = "bottom" },
    },
}

local plugin
local function fff()
    if not plugin then
        vim.cmd.packadd("fff")
        plugin = require("fff")
    end
    return plugin
end

vim.keymap.set("n", "<leader>ff", function() fff().find_files() end)
vim.keymap.set("n", "<leader>fg", function() fff().live_grep() end)
vim.keymap.set("n", "<leader>fr", function() fff().resume() end)
