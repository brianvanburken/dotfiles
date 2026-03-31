vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        vim.pack.add({ "https://github.com/folke/snacks.nvim" })
        local snacks = require("snacks")
        if snacks.did_setup then return end
        snacks.setup({
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
                    },
                },
                icons = {
                    files = {
                        enabled = false,
                    },
                },
            },
        })

        vim.keymap.set("n", "<leader>ff", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
        vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep" })
        vim.keymap.set("n", "<leader>fr", function() Snacks.picker.resume() end, { desc = "Resume" })
        vim.keymap.set("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
        vim.keymap.set("n", "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end,
            { desc = "LSP Workspace Symbols" })
        vim.keymap.set("n", "<leader>fe", function() Snacks.explorer() end, { desc = "Explorer" })
        vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
    end,
})
