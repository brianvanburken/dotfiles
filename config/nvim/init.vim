call plug#begin(stdpath('data') . '/plugged')
Plug '/usr/local/opt/fzf', { 'on': ['Ag', 'Files', 'Buffers', 'Tags'] }
Plug 'brglng/ayu-vim', { 'branch': 'feature/set-background' }
" Plug 'ayu-theme/ayu-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf.vim', { 'on': ['Ag', 'Files', 'Buffers', 'Tags'] }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
call plug#end()

syntax on

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

let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
if s:mode ==? "dark"
    set background=dark
else
    set background=light
endif
colorscheme ayu

let mapleader = "\<Space>"

nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>g :Goyo<CR>

nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

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

function! SetBackgroundMode(...)
    let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
    if s:mode ==? "dark"
        let s:new_bg = "dark"
    else
        let s:new_bg = "light"
    endif
    if &background !=? s:new_bg
        let &background = s:new_bg
    endif
endfunction
call timer_start(5000, "SetBackgroundMode", {"repeat": -1})



" Coc.vim configuration
"
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
