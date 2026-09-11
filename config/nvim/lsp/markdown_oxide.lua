return {
    cmd = { "markdown-oxide" },
    filetypes = {
        "markdown",
    },
    root_dir = function(_, on_dir)
        on_dir(vim.fn.getcwd())
    end,
    on_attach = function(_, bufnr)
        vim.keymap.set("n", "gf", vim.lsp.buf.definition, { buffer = bufnr, desc = "Follow wikilink" })
    end,
}
