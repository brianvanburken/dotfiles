return {
    "williamboman/mason-lspconfig.nvim",
    event = "BufRead",
    cmd = "Mason",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        -- Mason
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
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
