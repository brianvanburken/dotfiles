vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
        require("mason").setup({
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
        })
    end,
})
