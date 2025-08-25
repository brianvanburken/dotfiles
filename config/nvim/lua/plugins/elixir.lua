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
                    enable = true,
                    spitfire = false,
                    init_options = {
                        experimental = {
                            completions = {
                                enable = true,
                            },
                        },
                    },
                },
                elixirls = {
                    enable = false,
                },
            }
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
}
