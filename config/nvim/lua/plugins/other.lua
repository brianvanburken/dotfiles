return {
    {
        "tpope/vim-eunuch",
        commit = "67f3dd32b4dcd1c427085f42ff5f29c7adc645c6",
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

                -- Rust
                Rule("|", "|", { "rust" }),
                Rule("<", ">", { "rust" }),
            })
        end
    }
}
