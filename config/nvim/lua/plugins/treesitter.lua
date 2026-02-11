return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash",
                "css",
                "eex",
                "elixir",
                "elm",
                "fish",
                "heex",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "nix",
                "regex",
                "ruby",
                "rust",
                "scss",
                "sql",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            },
            auto_install = false,
            sync_install = false,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        })
    end
}
