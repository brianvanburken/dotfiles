return {
    "shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
        require('ayu').setup({
            terminal = true,
            overrides = {
                Normal = { bg = "None" },
            },
        })
        vim.cmd.colorscheme "ayu"
    end,
}
