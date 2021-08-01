vim.api.nvim_command('packadd packer.nvim')
require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }
  use { 'junegunn/fzf.vim', cmd = {'Ag', 'Files'}, requires = { '/usr/local/opt/fzf' } }
  use { 'editorconfig/editorconfig-vim' }
  use { 'luxed/ayu-vim', config = 'vim.cmd [[colorscheme ayu]]' }
  use { 'neoclide/coc.nvim', branch = 'release', ft = { 'html', 'scss', 'typescript', 'lua', 'json' } }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-surround' }
end)

vim.o.clipboard = 'unnamed' -- Share Clipboard with OS
vim.o.cmdheight = 2
vim.o.hidden = true
vim.o.lazyredraw = true
vim.o.shortmess = vim.o.shortmess..'aoOstTWAIcqFS' -- Shorten all messages
vim.o.signcolumn = 'yes'
vim.o.statusline = '%t%m%r%=%c:%l'
vim.o.termguicolors = true -- enable true colors support
vim.o.timeoutlen = 400 -- 400 ms wait to sequence complete
vim.wo.wrap = false

vim.api.nvim_set_keymap('n', '<C-a>', ':Rg!<CR>', {})
vim.api.nvim_set_keymap('n', '<C-p>', ':Files!<CR>', {})

-- CoC config
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

-- GoTo code navigation.
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { silent = true })

-- Use K to show documentation in preview window.
-- Source https://old.reddit.com/r/neovim/comments/jqdmuo/calling_plugin_functions_from_lua/
vim.api.nvim_set_keymap('n', 'K', ':lua ShowDocumentation()<CR>', { silent = true })
function ShowDocumentation()
  local filetype = vim.bo.filetype
  if filetype == "vim" or filetype == "help" then
    vim.api.nvim_command("h " .. vim.fn.expand("<cword>"))
  elseif vim.call("coc#rpc#ready") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command(
      "!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>")
    )
  end
end
