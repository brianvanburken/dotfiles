vim.keymap.set("n", "<leader>z", function()
    vim.pack.add({ "https://github.com/folke/zen-mode.nvim" })
    require("zen-mode").toggle()
end, { desc = "Toggle Zen Mode" })
