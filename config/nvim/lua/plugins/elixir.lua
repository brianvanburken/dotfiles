local ft = { "elixir", "eelixir", "heex" }
return {
    {
        "synic/refactorex.nvim",
        ft = ft,
        opts = {
            auto_update = true,
            pin_version = nil,
        }
    },
    {
        "elixir-tools/elixir-tools.nvim",
        ft = ft,
        config = function()
            local elixir = require("elixir")
            local elixirls = require("elixir.elixirls")

            elixir.setup {
                projectionist = {
                    enable = false
                },
                nextls = {
                    enable = true
                },
                elixirls = {
                    enable = true,
                    settings = elixirls.settings {
                        dialyzerEnabled = false,
                        enableTestLenses = false,
                    },
                    on_attach = function()
                        vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
                    end,
                },
            }
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
}
