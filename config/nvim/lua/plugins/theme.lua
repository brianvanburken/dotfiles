return {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    opts = {
        styles = {
            bold = false,
            italic = false,
        },
    },
    init = function()
        vim.cmd.colorscheme "rose-pine"
    end,
}
