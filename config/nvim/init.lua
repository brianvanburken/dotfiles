-- Disable builtin plugins and providers
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logiPat",
    "logipat",
    "matchit",
    "matchparen",
    "netrw",
    "netrwFileHandlers",
    "netrwPlugin",
    "netrwSettings",
    "rrhelper",
    "spellfile_plugin",
    "tar",
    "tarPlugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    -- Providers
    "node_provider",
    "ruby_provider",
    "perl_provider",
    "python_provider",
    "python3_provider"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

vim.o.autoread = true -- Automatically reload files changed outside of vim
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 2
vim.o.hidden = true
vim.o.inccommand = "split" -- Show live preview of substitutions
vim.o.lazyredraw = true
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%t%m%r%=%c:%l"
vim.o.termguicolors = true -- enable true colors support
vim.wo.wrap = false
vim.o.background = "light"

require("packer").startup(
    function(use)
        use {"christoomey/vim-tmux-navigator"}
        use {"editorconfig/editorconfig-vim"}
        use {"ludovicchabant/vim-gutentags"}
        use {
            "junegunn/fzf.vim",
            requires = "/usr/local/opt/fzf",
            config = function()
                vim.api.nvim_set_keymap("n", "<C-a>", ":Rg!<CR>", {})
                vim.api.nvim_set_keymap("n", "<C-p>", ":Files!<CR>", {})
                vim.api.nvim_set_keymap("n", "<C-t>", ":Tags!<CR>", {})
            end
        }
        use {
            "shatur/neovim-ayu",
            config = function()
                vim.cmd [[
                colorscheme ayu
                highlight Normal ctermbg=none guibg=none
                highlight NonText ctermbg=none guibg=none
                ]]
            end
        }
        use {
            "neoclide/coc.nvim",
            branch = "release",
            config = function()
                -- Use `[g` and `]g` to navigate diagnostics
                -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
                vim.api.nvim_set_keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
                vim.api.nvim_set_keymap("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

                -- GoTo code navigation.
                vim.api.nvim_set_keymap("n", "gd", "<Plug>(coc-definition)", {silent = true})
                vim.api.nvim_set_keymap("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
                vim.api.nvim_set_keymap("n", "gi", "<Plug>(coc-implementation)", {silent = true})
                vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", {silent = true})

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
                            "html",
                            "javascript",
                            "jsdoc",
                            "json",
                            "lua",
                            "regex",
                            "ruby",
                            "rust",
                            "scss",
                            "tsx",
                            "yaml"
                        },
                        highlight = {
                            enable = true,
                            use_languagetree = true
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
        use {"wbthomason/packer.nvim"}
    end
)
