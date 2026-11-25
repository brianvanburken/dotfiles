vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = vim.schedule_wrap(function()
        vim.cmd.packadd("nvim-surround")
        require("nvim-surround").setup()
    end),
})
