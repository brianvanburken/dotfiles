return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPre",
        opts = {
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
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        }
    },
}
