-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Disable some providers
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0

vim.o.clipboard = "unnamed" -- Share Clipboard with OS
vim.o.cmdheight = 2
vim.o.hidden = true
vim.o.lazyredraw = true
vim.o.shortmess = vim.o.shortmess .. "aoOstTWAIcqFS" -- Shorten all messages
vim.o.signcolumn = "yes"
vim.o.statusline = "%t%m%r%=%c:%l"
vim.o.termguicolors = true -- enable true colors support
vim.o.timeoutlen = 400 -- 400 ms wait to sequence complete
vim.wo.wrap = false

-- Packer
vim.api.nvim_command("packadd packer.nvim")
require("packer").startup(
    function(use)
        use {"editorconfig/editorconfig-vim"}
        use {"junegunn/fzf.vim", cmd = {"Ag", "Files", "Tags"}, requires = {"/usr/local/opt/fzf"}}
        use {"ludovicchabant/vim-gutentags"}
        use {"luxed/ayu-vim", config = "vim.cmd [[colorscheme ayu]]"}
        use {"neoclide/coc.nvim", branch = "release", ft = {"html", "scss", "typescript", "lua", "json"}}
        use {"tpope/vim-commentary"}
        use {"tpope/vim-surround"}
        use {"wbthomason/packer.nvim", opt = true}
    end
)

vim.api.nvim_set_keymap("n", "<C-q>", ":lua ToggleBackground()<CR>", {})
function ToggleBackground()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end

-- Fzf
vim.api.nvim_set_keymap("n", "<C-a>", ":Rg!<CR>", {})
vim.api.nvim_set_keymap("n", "<C-p>", ":Files!<CR>", {})
vim.api.nvim_set_keymap("n", "<C-t>", ":Tags!<CR>", {})

-- CoC
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
-- Source https://old.reddit.com/r/neovim/comments/jqdmuo/calling_plugin_functions_from_lua/
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
