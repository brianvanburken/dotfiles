return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<CR>" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
        { "<leader>fc", "<cmd>Telescope commands<CR>" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>" },
        { "<leader>fd", "<cmd>Telescope diagnostics<CR>" },
    },
    opts = {
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    },
}
