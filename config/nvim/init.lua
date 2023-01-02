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
vim.o.statusline = "%f%<%m%r"
vim.o.termguicolors = true -- enable true colors support
vim.o.updatetime = 50
vim.o.writebackup = false
vim.wo.wrap = false

-- Move visually selected blocks to move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor where it is when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Paste but keep current registry
vim.keymap.set("n", "<leader>p", "\"_d")
vim.keymap.set("v", "<leader>p", "\"_d")
vim.keymap.set("x", "<leader>p", "\"_d")


-- Setup Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {"christoomey/vim-tmux-navigator"},
    {"editorconfig/editorconfig-vim"},
    {
        "ibhagwan/fzf-lua",
        keys = {
            { "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>"},
            { "<C-t>", "<cmd>lua require('fzf-lua').tags()<CR>"},
            { "<C-a>", "<cmd>lua require('fzf-lua').live_grep()<CR>"},
            { "<C-i>", "<cmd>lua require('fzf-lua').builtin()<CR>"},
        },
        config = {
            winopts = {
                fullscreen = true
            },
            fzf_opts = {
                ['--layout'] = "default",
            },
        }
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function ()
            require("gruvbox").setup({
                contrast = "hard"
            })
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        "neoclide/coc.nvim",
        build = ":CocUpdate",
        branch = "release",
        config = function() require('coc') end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        init = function ()
            vim.o.foldmethod = "expr"
            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            vim.o.foldlevel = 20
        end,
        config = {
            ensure_installed = {
                "bash",
                "css",
                "elm",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "regex",
                "ruby",
                "rust",
                "scss",
                "toml",
                "tsx",
                "typescript",
                "yaml"
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                use_languagetree = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm"
                }
            }
        }
    },
    {"tpope/vim-abolish"},
    {"tpope/vim-commentary"},
    {
        "tpope/vim-eunuch",
        cmd = "Rename"
    },
    {"tpope/vim-surround"},
}, {
    install = {
        colorscheme = { "gruvbox" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        }
    }
})
