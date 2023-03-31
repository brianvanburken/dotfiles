return {
    "rose-pine/neovim",
    event = "VeryLazy",
    name = "rose-pine",
    init = function()
        vim.cmd("colorscheme rose-pine")
    end,
    opts = true,
}
