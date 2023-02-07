return {
    {
        "folke/twilight.nvim",
        cmd = {
            "Twilight",
            "TwilightEnable",
            "TwilightDisable",
        },
        opt = true,
    },
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { "<leader>z", "<cmd>ZenMode<CR>" },
        },
        opt = {
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
