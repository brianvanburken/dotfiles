return {
    cmd = { "tsgo", "--lsp", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = {
        "tsconfig.json",
        "jsconfig.json",
        "package.json",
        ".git",
    },
}
