return {
    {
        "folke/twilight.nvim",
        version = "~1.0.0",
        cmd = {
            "Twilight",
            "TwilightEnable",
            "TwilightDisable",
        },
        opts = true,
    },
    {
        "folke/zen-mode.nvim",
        version = "~1.2.0",
        cmd = "ZenMode",
        keys = {
            { "<leader>z", "<cmd>ZenMode<CR>" },
        },
        opts = {
            window = {
                options = {
                    number = false,
                    foldcolumn = "0",
                },
            },
            plugins = {
                tmux = { enabled = true },
            },
        },
    },
}
