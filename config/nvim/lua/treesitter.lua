require("nvim-treesitter.configs").setup(
    {
        ensure_installed = {
            "bash",
            "css",
            "dockerfile",
            "eex",
            "elixir",
            "elm",
            "heex",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "lua",
            "regex",
            "ruby",
            "rust",
            "scss",
            "toml",
            "tsx",
            "typescript",
            "yaml"
        },
        highlight = {
            enable = true,
            use_languagetree = true
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm"
            }
        }
    }
)

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 20
