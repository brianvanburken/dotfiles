return {
    "rose-pine/neovim",
    version = "~1.2.0",
    event = "VeryLazy",
    name = "rose-pine",
    init = function()
        vim.cmd("colorscheme rose-pine")
    end,
    opts = true,
}
