return {
    -- {
    --     "rose-pine/neovim",
    --     version = "~1.2.0",
    --     event = "VeryLazy",
    --     name = "rose-pine",
    --     init = function()
    --         vim.cmd("colorscheme rose-pine")
    --     end,
    --     opts = true,
    -- },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     init = function()
    --         vim.cmd("colorscheme catppuccin")
    --     end,
    --     opts = true,
    -- },
    {
        "jesseleite/nvim-noirbuddy",
        name = "noirbuddy",
        dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" },
        priority = 1000,
        init = function()
            vim.cmd("colorscheme noirbuddy")
            require("noirbuddy").setup({
                colors = {
                    primary = "#F2A43C",
                },
            })

            -- Ensure background is transparent after the theme is loaded
            vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
        end,
    },
}
