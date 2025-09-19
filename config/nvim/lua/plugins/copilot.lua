return {
    "zbirenbaum/copilot.lua",
    event = "BufReadPost",
    opts  = {
        panel = {
            enabled = false
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            hide_during_completion = true,
            keymap = {
                accept = "<D-y>",
                next = "<D-j>",
                prev = "<D-k>",
                dismiss = "<C-c>",
            },
        },
        server_opts_overrides = {},
        filetypes = {
            javascript = true,
            typescript = true,
            rust = true,
            lua = true,
            elixir = true,
            elm = true,
            ["*"] = false
        },
    },
}
