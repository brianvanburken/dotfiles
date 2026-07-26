vim.pack.add({ "https://github.com/shatur/neovim-ayu" })
require("ayu").setup({
    overrides = {
        Normal = { bg = "None" },
        NormalNC = { bg = "None" },
        SignColumn = { bg = "None" },
        FoldColumn = { bg = "None" },
    },
})
vim.cmd.colorscheme("ayu")
