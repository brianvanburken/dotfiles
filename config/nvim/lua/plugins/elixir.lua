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

            elixir.setup {
                projectionist = {
                    enable = false
                },
                credo = {
                    enable = false
                },
                nextls = {
                    enable = false,
                },
                elixirls = {
                    enable = true,
                },
            }
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
}
