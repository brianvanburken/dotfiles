return {
    "zbirenbaum/copilot.lua",
    cmd  = "Copilot",
    keys = {
        {
            "<D-j>", -- Cmd+j on macOS
            function() require("copilot.suggestion").next() end,
            mode = "i",
            desc = "Next copilot suggestion",
        },
        {
            "<D-k>", -- Cmd+k on macOS
            function() require("copilot.suggestion").prev() end,
            mode = "i",
            desc = "Prev copilot suggestion",
        },
    },
    opts = {
        panel = {
            enabled = false
        },
        suggestion = {
            enabled = true,
            auto_trigger = false,
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
