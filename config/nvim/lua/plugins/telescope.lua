return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>fc", "<cmd>Telescope commands<CR>" },
        { "<leader>fd", "<cmd>Telescope diagnostics<CR>" },
        { "<leader>ff", "<cmd>Telescope find_files<CR>" },
        { "<leader>fh", "<cmd>Telescope find_files hidden=true<CR>" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
        { "<leader>fr", "<cmd>Telescope resume<CR>" },
        { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
        { "<leader>ft", "<cmd>TodoTelescope<CR>" },
    },
    opts = {
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    },
}
