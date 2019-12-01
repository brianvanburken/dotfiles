call plug#begin()
Plug 'andys8/vim-elm-syntax'
Plug 'ayu-theme/ayu-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rizzatti/dash.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround'
call plug#end()

filetype plugin indent on " Load filetype-specific indent files
syntax on

let mapleader = "\<Space>"

set background=dark
set backspace=indent,eol,start
set clipboard=unnamed " Share Clipboard with OS
set hlsearch " highlight matches
set incsearch " search as characters are entered
set laststatus=2 " Always enable status line
set lazyredraw
set nocompatible
set nowrap
set number " Show line numbers
set numberwidth=3 " Line numbers max digits
set scrolloff=5 " Show lines below current line at all times while scrolling
set showcmd " Show typed command in bottom bar
set signcolumn=yes
set termguicolors
set ttyfast

set statusline=%t " Tail of the filename
set statusline+=%m " Modified flag
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}] " File encoding/format
set statusline+=%h " Help file flag
set statusline+=%r " Read only flag
set statusline+=%y " Filetype
set statusline+=%= " Left/right separator
set statusline+=%l/%L: " Cursor line/total lines
set statusline+=%c " Cursor column

au BufEnter .envrc setlocal filetype=sh
au BufEnter *.md setlocal filetype=markdown
au BufEnter *.tsx setlocal filetype=typescript.tsx
au FileType gitcommit,markdown setlocal spell

let g:ayucolor="dark"
colorscheme ayu

" Set background color to none
hi Normal ctermbg=NONE guibg=NONE

nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>

nnoremap <Leader>d :Dash<CR>

nnoremap <Leader>r :Rename<Space>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
