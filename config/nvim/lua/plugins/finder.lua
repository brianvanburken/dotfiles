return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        keys = {
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>" },
            { "<leader>ff", "<cmd>Telescope find_files<CR>" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
            { "<leader>fr", "<cmd>Telescope resume<CR>" },
            { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
        },
        opts = {
            pickers = {
                find_files = {
                    hidden = true,
                    previewer = false,
                    layout_strategy = "vertical",
                },
            },
            defaults = {
                border = false,
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                    },
                    vertical = {
                        prompt_position = "top",
                    },
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim"
                }

            }
        },
    }
}
