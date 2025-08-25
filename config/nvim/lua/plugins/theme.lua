return {
    "shatur/neovim-ayu",
    cmd = "Colorscheme",
    init = function()
        require('ayu').setup({
            terminal = true,
            overrides = {
                Normal = { bg = "None" },
            },
        })
        vim.cmd.colorscheme "ayu"
    end,
}
