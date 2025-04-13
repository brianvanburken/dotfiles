return {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = {
        "css",
        "scss",
        "less"
    },
    settings = {
        provideFormatter = true,
        css = {
            validate = true
        },
        less = {
            validate = true
        },
        scss = {
            validate = true
        }
    }
}
