vim.pack.add({ "https://github.com/shatur/neovim-ayu" })
require("ayu").setup({
    terminal = true,
    overrides = {
        Normal = { bg = "None" },
    },
})
vim.cmd.colorscheme("ayu")
