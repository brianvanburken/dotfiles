return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>ff", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
        { "<leader>fg", function() Snacks.picker.grep() end,                  desc = "Grep" },
        { "<leader>ff", function() Snacks.picker.files() end,                 desc = "Find Files" },
        { "<leader>fr", function() Snacks.picker.resume() end,                desc = "Resume" },
        { "<leader>fs", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
        { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        { "grr",        function() Snacks.picker.lsp_references() end,        desc = "References",           nowait = true },
    },
    opts = function()
        -- Fix for directory names unreadable in neovim-ayu
        vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Normal" })
        return {
            picker = {
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
                bigfile = { enabled = false },
                dashboard = { enabled = false },
                explorer = { enabled = false },
                indent = { enabled = false },
                input = { enabled = false },
                notifier = { enabled = false },
                quickfile = { enabled = false },
                scope = { enabled = false },
                scroll = { enabled = false },
                statuscolumn = { enabled = false },
                words = { enabled = false },

            }
        }
    end
}
