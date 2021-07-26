call plug#begin(stdpath('data') . '/plugged')
Plug '/usr/local/opt/fzf', { 'on': ['Ag', 'Files', 'Buffers'] }
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf.vim', { 'on': ['Ag', 'Files', 'Buffers'] }
Plug 'luxed/ayu-vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
call plug#end()

set clipboard=unnamed " Share Clipboard with OS
set cmdheight=2
set hidden
set nobackup
set nowrap
set nowritebackup
set number " Show line numbers
set numberwidth=3 " Line numbers max digits
set scrolloff=5 " Show lines below current line at all times while scrolling
set shortmess+=c " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes
set termguicolors " enable true colors support

set statusline=%t " Tail of the filename
set statusline+=%m " Modified flag
set statusline+=%r " Read only flag
set statusline+=\ [%{&fileencoding?&fileencoding:&encoding}]
set statusline+=%= " Left/right separator
set statusline+=%c:%l/%L " Cursor 'column:line/total'

au BufEnter .envrc setlocal filetype=sh
au BufEnter *.md setlocal filetype=markdown

colorscheme ayu

nnoremap <C-a> :Rg!<cr>
nnoremap <C-p> :Files!<cr>

" CoC config
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nmap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
