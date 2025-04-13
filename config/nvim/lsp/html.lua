return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    settings = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true
        },
        provideFormatter = true
    }
}
