vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.o.autoread = true -- Automatically reload files changed outside of vim
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 1
vim.o.expandtab = true
vim.o.fcs = vim.o.fcs .. "eob: " -- hide EndOfBuffer characters
vim.o.hidden = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.lazyredraw = true
vim.o.list = true
vim.o.nu = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%f%<%m%r"
vim.o.tabstop = 2
vim.o.termguicolors = true -- enable true colors support
vim.o.updatetime = 50
vim.o.writebackup = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.wo.wrap = false
vim.o.background = "light"

-- Map <leader> to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move visually selected blocks to move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor where it is when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Paste but keep current registry
vim.keymap.set("n", "<leader>p", '"_d')
vim.keymap.set("v", "<leader>p", '"_d')
vim.keymap.set("x", "<leader>p", '"_d')

-- URL handling (custom for when netrw is disabled and don't provide functionality)
if vim.fn.has("mac") == 1 then
    vim.keymap.set("n", "gx", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>')
elseif vim.fn.has("unix") == 1 then
    vim.keymap.set("n", "gx", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>')
end

-- Setup Lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup("plugins", {
    defaults = { lazy = true },
    debug = false,
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "osc52",
                "rplugin",
                "rrhelper",
                "shada",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
})
