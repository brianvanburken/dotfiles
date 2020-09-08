call plug#begin(stdpath('data') . '/plugged')
Plug '/usr/local/opt/fzf', { 'on': ['Ag', 'Files', 'Buffers', 'Tags'] }
Plug 'ayu-theme/ayu-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf.vim', { 'on': ['Ag', 'Files', 'Buffers', 'Tags'] }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
call plug#end()

syntax on

set background=dark
set backspace=indent,eol,start
set clipboard=unnamed " Share Clipboard with OS
set hlsearch " highlight matches
set incsearch " search as characters are entered
set laststatus=2 " Always enable status line
set linebreak
set nowrap
set number " Show line numbers
set numberwidth=3 " Line numbers max digits
set scrolloff=5 " Show lines below current line at all times while scrolling
set showcmd " Show typed command in bottom bar
set signcolumn=yes
set termguicolors " enable true colors support

set statusline=%t " Tail of the filename
set statusline+=%m " Modified flag
set statusline+=%h " Help file flag
set statusline+=%r " Read only flag
set statusline+=\ %y " Filetype
set statusline+=%= " Left/right separator
set statusline+=%c:%l/%L " Cursor 'column:line/total'

au BufEnter .envrc setlocal filetype=sh
au BufEnter *.md setlocal filetype=markdown
au BufEnter *.tsx setlocal filetype=typescript.tsx
au FileType gitcommit,markdown setlocal spell

colorscheme ayu

let mapleader = "\<Space>"

nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>g :Goyo 85<CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)

nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Goyo + Limelight settings
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    set nocursorline
    CocDisable
    Limelight
endfunction

function! s:goyo_leave()
    set showmode
    set showcmd
    set cursorline
    CocEnable
    Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
