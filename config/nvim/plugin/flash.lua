local plugin
local function flash()
    if not plugin then
        vim.pack.add({ "https://github.com/folke/flash.nvim" })
        plugin = require("flash")
        plugin.setup()
    end
    return plugin
end

vim.keymap.set({ "n", "x", "o" }, "s", function() flash().jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash().treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() flash().remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() flash().treesitter_search() end, { desc = "Treesitter Search" })
