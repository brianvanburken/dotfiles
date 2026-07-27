vim.loader.enable()

-- Disable unused built-in plugins to speed up startup
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_man = 1
vim.g.loaded_nvim_net_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.editorconfig = false

vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.laststatus = 3
vim.o.list = true
vim.o.nrformats = "unsigned"
vim.o.number = true
vim.o.shortmess = vim.o.shortmess .. "astWAIcqS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.updatetime = 250                           -- Faster CursorHold for LSP hover/diagnostics (default: 4000)
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Handling of whitespace
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Map <leader> to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move visually selected blocks to move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor where it is when joining lines
vim.keymap.set("n", "J", "mzJ`z")

vim.api.nvim_create_user_command("Remove", function()
    local path = vim.fn.expand("%")
    vim.fn.delete(path)
    vim.cmd("bdelete!")
end, {})

vim.api.nvim_create_user_command("Rename", function(o)
    local old = vim.fn.expand("%:p")
    local new = vim.fn.fnamemodify(old, ":h") .. "/" .. o.args
    vim.fn.rename(old, new)
    vim.cmd("edit " .. new)
    vim.cmd("bdelete! #")
end, { nargs = 1, complete = "file" })
