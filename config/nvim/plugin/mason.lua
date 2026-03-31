vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
        require("mason").setup()
    end,
})
