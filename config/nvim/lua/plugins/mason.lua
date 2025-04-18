return {
    "williamboman/mason.nvim",
    version = "~1.7.0",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        ensure_installed = {
            "biome",
            "css-lsp",
            "elixir-ls",
            "elm-language-server",
            "html-lsp",
            "vscode-json-language-server",
            "lua-language-server",
            "rust-analyzer",
            "stylua",
            "tailwindcss-language-server",
            "taplo",
            "typescript-language-server",
            "yaml-language-server",
        },
    }
}
