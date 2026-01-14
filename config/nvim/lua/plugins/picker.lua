return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>ff", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
        { "<leader>fg", function() Snacks.picker.grep() end,                  desc = "Grep" },
        { "<leader>ff", function() Snacks.picker.files() end,                 desc = "Find Files" },
        { "<leader>fr", function() Snacks.picker.resume() end,                desc = "Resume" },
        { "<leader>fs", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
        { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        { "<leader>fe", function() Snacks.explorer() end,                     desc = "Explorer" },
        { "grr",        function() Snacks.picker.lsp_references() end,        desc = "References",           nowait = true },
    },
    opts = {
        picker = {
            sources = {
                explorer = { hidden = true },
                files = { hidden = true },
                grep = { hidden = true },
            },
            show_delay = 0,
            smart = {
                matcher = {
                    frecency = true,
                }
            },
            icons = {
                files = {
                    enabled = false
                }
            },
        }
    }
}
