return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
    opts = {
        panel = { enabled = true },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            hide_during_completion = true,
            debounce = 75,
            keymap = {
                accept = "<c-j>",
            },
        },
        server_opts_overrides = {},
    },
}
