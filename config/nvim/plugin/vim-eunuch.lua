vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/tpope/vim-eunuch" })
    end,
})
