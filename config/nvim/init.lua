vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0

vim.o.autoread = true -- Automatically reload files changed outside of vim
vim.o.background = "dark"
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 2
vim.o.fcs = vim.o.fcs .. "eob: " -- hide EndOfBuffer characters
vim.o.hidden = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.lazyredraw = true
vim.o.nu = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%t%m%r%=%c:%l/%L"
vim.o.termguicolors = true -- enable true colors support
vim.o.updatetime = 50
vim.o.writebackup = false
vim.wo.wrap = false

-- Move visually selected blocks to move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor where it is when joining lines
vim.keymap.set("n", "J", "mzJ`z")

require("packer").startup(
    function(use)
        use {"christoomey/vim-tmux-navigator"}
        use {"editorconfig/editorconfig-vim"}
        use {
            "junegunn/fzf",
            requires = "junegunn/fzf.vim",
            run = ":call fzf#install()",
            config = function() require('fzf') end
        }
        use {
            "ellisonleao/gruvbox.nvim",
            config = function() require('theme') end
        }
        use {
            "neoclide/coc.nvim",
            branch = "release",
            config = function() require('coc') end
        }
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function() require("treesitter") end
        }
        use {"tpope/vim-commentary"}
        use {"tpope/vim-surround"}
        use {"tpope/vim-eunuch"}
        use {"wbthomason/packer.nvim"}
    end
)
