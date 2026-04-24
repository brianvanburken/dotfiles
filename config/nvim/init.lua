vim.loader.enable()

vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.laststatus = 3
vim.o.list = true
vim.o.nrformats = "unsigned"
vim.o.number = true
vim.o.shortmess = vim.o.shortmess .. "astWAIcqS" -- Shorten all messages
vim.o.signcolumn = "yes"
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

-- Add filetypes
vim.filetype.add({
    extension = {
        avsc = 'json',
    },
    pattern = {
        ['.*/ghostty/config'] = { 'dosini', { priority = 10 } },
    },
})

vim.api.nvim_create_user_command("PackUpdate", function() vim.pack.update() end, {})

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

vim.diagnostic.config({
    float = { border = "rounded" },
    underline = true,
    virtual_text = true,
    virtual_lines = false,
})
