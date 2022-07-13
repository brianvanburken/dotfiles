vim.o.autoread = true -- Automatically reload files changed outside of vim
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 2
vim.o.fcs = vim.o.fcs .. "eob: " -- hide EndOfBuffer characters
vim.o.hidden = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.lazyredraw = true
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%t%m%r%=%c:%l/%L"
vim.o.termguicolors = true -- enable true colors support
vim.wo.wrap = false
vim.o.background = "light"

require("packer").startup(
    function(use)
        use {"christoomey/vim-tmux-navigator"}
        use {"editorconfig/editorconfig-vim"}
        use {
            "junegunn/fzf",
            requires = "junegunn/fzf.vim",
            run = ":call fzf#install()",
            config = function()
                vim.env.FZF_DEFAULT_COMMAND = "fd -tf -H -i -L"
                vim.env.FZF_CTRL_T_COMMAND = vim.env.FZF_DEFAULT_COMMAND
                vim.env.FZF_ALT_C_COMMAND = vim.env.FZF_DEFAULT_COMMAND
                vim.env.FZF_DEFAULT_OPTS = "--ansi"

                vim.api.nvim_set_keymap("n", "<C-p>", ":Files!<CR>", {})
                vim.api.nvim_set_keymap("n", "<C-f>", ":Rg!<CR>", {})
            end
        }
        use {
            "shatur/neovim-ayu",
            config = function()
                vim.cmd("colorscheme ayu")
                vim.cmd("highlight Normal ctermbg=none guibg=none")
                vim.cmd("highlight NonText ctermbg=none guibg=none")
            end
        }
        use {
            "neoclide/coc.nvim",
            branch = "release",
            config = function()
                vim.g.coc_global_extensions = {
                    "coc-css",
                    "coc-elixir",
                    "coc-html",
                    "coc-html-css-support",
                    "coc-json",
                    "coc-lua",
                    "coc-prettier",
                    "coc-rust-analyzer",
                    "coc-snippets",
                    "coc-tsserver"
                }

                -- Use `[g` and `]g` to navigate diagnostics
                -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
                vim.api.nvim_set_keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
                vim.api.nvim_set_keymap("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

                -- GoTo code navigation.
                vim.api.nvim_set_keymap("n", "gd", "<Plug>(coc-definition)", {silent = true})
                vim.api.nvim_set_keymap("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
                vim.api.nvim_set_keymap("n", "gi", "<Plug>(coc-implementation)", {silent = true})
                vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", {silent = true})

                vim.api.nvim_set_keymap("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

                -- Use K to show documentation in preview window.
                vim.api.nvim_set_keymap("n", "K", ":lua ShowDocumentation()<CR>", {silent = true})
                function ShowDocumentation()
                    local filetype = vim.bo.filetype
                    if filetype == "vim" or filetype == "help" then
                        vim.api.nvim_command("h " .. vim.fn.expand("<cword>"))
                    elseif vim.call("coc#rpc#ready") then
                        vim.fn.CocActionAsync("doHover")
                    else
                        vim.api.nvim_command("!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>"))
                    end
                end
            end
        }
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup(
                    {
                        ensure_installed = {
                            "bash",
                            "css",
                            "dockerfile",
                            "eex",
                            "elixir",
                            "elm",
                            "heex",
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
                        highlight = {
                            enable = true,
                            use_languagetree = true
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

                vim.o.foldmethod = "expr"
                vim.o.foldexpr = "nvim_treesitter#foldexpr()"
                vim.o.foldlevel = 20
            end
        }
        use {"tpope/vim-commentary"}
        use {"tpope/vim-surround"}
        use {"tpope/vim-eunuch"}
        use {"wbthomason/packer.nvim"}
    end
)
