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
vim.keymap.set("n", "<leader>p", '"_d')
vim.keymap.set("v", "<leader>p", '"_d')
vim.keymap.set("x", "<leader>p", '"_d')

-- Setup Lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup(
    {
        {
            "ibhagwan/fzf-lua",
            keys = {
                {"<C-p>", "<cmd>lua require('fzf-lua').files()<CR>"},
                {"<C-t>", "<cmd>lua require('fzf-lua').tags()<CR>"},
                {"<C-a>", "<cmd>lua require('fzf-lua').live_grep()<CR>"},
                {"<C-i>", "<cmd>lua require('fzf-lua').builtin()<CR>"},
                {"<leader>c", "<cmd>lua require('fzf-lua').commands()<CR>"}
            },
            config = {
                winopts = {
                    fullscreen = true
                },
                fzf_opts = {
                    ["--layout"] = "default"
                }
            }
        },
        {
            "ellisonleao/gruvbox.nvim",
            init = function()
                vim.cmd("colorscheme gruvbox")
            end,
            config = {
                contrast = "hard"
            }
        },
        {
            "neoclide/coc.nvim",
            build = ":CocUpdate",
            branch = "release",
            event = "BufReadPost",
            config = function()
                require("coc")
            end
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            event = "BufReadPost",
            config = function()
                vim.o.foldmethod = "expr"
                vim.o.foldexpr = "nvim_treesitter#foldexpr()"
                vim.o.foldlevel = 20
                require("nvim-treesitter.configs").setup(
                    {
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
                            "yaml",
                            "vim"
                        },
                        sync_install = false,
                        auto_install = false,
                        highlight = {
                            enable = true,
                            use_languagetree = true,
                            additional_vim_regex_highlighting = false
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
                )
            end
        },
        {"tpope/vim-abolish", event = "BufReadPost"},
        {"tpope/vim-commentary", event = "BufReadPost"},
        {"tpope/vim-eunuch", cmd = { "Rename", "Remove", "Delete", "Move", "Mkdir"}},
        {"tpope/vim-surround", event = "BufReadPost"},
        {"christoomey/vim-tmux-navigator", event = "BufReadPost"},
        {"editorconfig/editorconfig-vim", event = "BufReadPost"},
    },
    {
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
                    "rplugin",
                    "rrhelper",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "vimball",
                    "vimballPlugin",
                    "zip",
                    "zipPlugin",
                }
            }
        }
    }
)
