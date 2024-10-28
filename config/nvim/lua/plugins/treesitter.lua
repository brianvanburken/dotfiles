return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = "~0.9",
        build = ":TSUpdate",
        event = "BufReadPost",
        config = function()
            vim.o.foldmethod = "expr"
            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            vim.o.foldlevel = 20
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "css",
                    "elm",
                    "fish",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "lua",
                    "markdown",
                    "markdown_inline",
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
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    use_languagetree = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
        end,
    },
}
