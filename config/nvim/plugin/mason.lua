local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
if not vim.list_contains(vim.split(vim.env.PATH, ":", { plain = true }), mason_bin) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.api.nvim_create_autocmd("CmdUndefined", {
    pattern = "Mason*",
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
        require("mason").setup({ PATH = "skip" })
    end,
})
