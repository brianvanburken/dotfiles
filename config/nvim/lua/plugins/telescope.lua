return {
    "nvim-telescope/telescope.nvim",
    version = "~0.1.2",
    cmd = "Telescope",
    dependencies = {
        { "nvim-lua/plenary.nvim", version = "~0.1.3" },
    },
    keys = {
        { "<leader>fc", "<cmd>Telescope commands<CR>" },
        { "<leader>fd", "<cmd>Telescope diagnostics<CR>" },
        { "<leader>ff", "<cmd>Telescope find_files<CR>" },
        { "<leader>fh", "<cmd>Telescope find_files hidden=true<CR>" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
        { "<leader>fr", "<cmd>Telescope resume<CR>" },
        { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
    },
    opts = {
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    },
}
