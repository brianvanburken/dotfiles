return {
    {
        "mason-org/mason.nvim",
        event = "BufReadPost",
        opts = {
            ensure_installed = {
                "biome",
                "css-lsp",
                "elm-format",
                "elm-language-server",
                "expert",
                "html-lsp",
                "lua-language-server",
                "rust-analyzer",
                "tailwindcss-language-server",
                "taplo",
                "typescript-language-server",
                "vscode-json-language-server",
                "yaml-language-server",
            },
        }
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = { relative = "editor" },
            },
        }
    }
}
