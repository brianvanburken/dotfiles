return {
    "williamboman/mason-lspconfig.nvim",
    event = "BufRead",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        -- Mason
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "sumneko_lua",
                "rust_analyzer",
                "cssls",
                "elmls",
                "html",
                "jsonls",
                "yamlls",
                "taplo",
                "tsserver",
            },
        })
    end,
}
