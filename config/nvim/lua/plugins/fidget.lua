return {
    "j-hui/fidget.nvim",
    tag = "v1.4.0",
    event = "BufReadPost",
    opts = { window = { relative = "editor" } },
    dependencies = { "neovim/nvim-lspconfig" },
}
