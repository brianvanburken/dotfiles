return {
    {
        "folke/twilight.nvim",
        cmd = {
            "Twilight",
            "TwilightEnable",
            "TwilightDisable",
        },
        opts = true,
    },
    {
        "folke/zen-mode.nvim",
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
