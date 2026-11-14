vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = vim.schedule_wrap(function()
        vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
        require("nvim-surround").setup()
    end),
})
