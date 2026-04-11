vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/folke/zen-mode.nvim" })
        vim.keymap.set("n", "<leader>z", function() require("zen-mode").toggle() end, { desc = "Toggle Zen Mode" })
    end,
})
