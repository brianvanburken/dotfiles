return {
    {
        "tpope/vim-eunuch",
        cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir", "Copy" },
    },
    {
        "kylechui/nvim-surround",
        keys = { "cs", "ds", "ys" },
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            local Rule   = require("nvim-autopairs.rule")

            npairs.setup({ check_ts = true })
            npairs.add_rules({
                -- Elixir
                Rule(" do", " end", { "elixir", "eelixir", "heex" }),
                Rule(" ->", " end", { "elixir", "eelixir", "heex" }),
                Rule("<%", " %>", { "elixir", "eelixir", "heex" }),
                Rule("__", "__", { "elixir", "eelixir", "heex" }),

                -- Rust
                Rule("|", "|", { "rust" }),
                Rule("<", ">", { "rust" }),
            })
        end
    },
    {
        "nguyenvukhang/nvim-toggler",
        keys = { "<leader>i" },
        opts = {
            inverses = {
                -- Markdown checkboxes
                ["[ ]"] = "[x]",
                ["[x]"] = "[ ]",
            }
        },
    }
}
