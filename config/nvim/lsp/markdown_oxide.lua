return {
    cmd = { "markdown-oxide" },
    filetypes = {
        "markdown",
    },
    root_dir = function(_, on_dir)
        on_dir(vim.fn.getcwd())
    end
}
