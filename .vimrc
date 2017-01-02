autocmd!

call plug#begin()

" Language
Plug 'elixir-lang/vim-elixir',  { 'for': ['erlang', 'elixir', 'eelixir'] }
Plug 'elmcast/elm-vim',         { 'for': ['elm'] }
Plug 'othree/html5.vim',        { 'for': ['html', 'eelixir'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'mxw/vim-jsx',             { 'for': ['javascript'] }

" Code display
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'

" Integrations
Plug 'rizzatti/dash.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-commentary'

" Interface
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'

" Commands
Plug 'tpope/vim-surround'

" Other
Plug 'avdgaag/vim-phoenix',     { 'for': ['erlang', 'elixir', 'eelixir'] }
Plug 'slashmili/alchemist.vim', { 'for': ['erlang', 'elixir', 'eelixir'] }

call plug#end()

" ---------- SYSTEM

" Force the use of Vim movement
nnoremap <Left>  <NOP>
nnoremap <Right> <NOP>
nnoremap <Up>    <NOP>
nnoremap <Down>  <NOP>

" Vim will keep highlighted matches from searches until you either run a new
" one or manually stop highlighting the old search with :nohlsearch. I find
" myself running this all the time so I've mapped it to <leader><space>.
nnoremap <space><space> :nohlsearch<CR>

" Highlight trailing whitespace
match ErrorMsg /\\\@<![\u3000[:space:]]\+$/

filetype indent on                 " Load filetype-specific indent files

let mapleader = " "

set noswapfile
set nowritebackup
set nobackup
set t_Co=256
set background=dark
set termencoding=utf-8             " Set encoding to UTF-8
set encoding=utf-8                 " Set default encoding to UTF-8
set colorcolumn=81                 " Show column on 81 character for limit reference
set nowrap                         " Set no line wrap
set expandtab                      " Use spaces not tabs
set tabstop=2                      " A tab is two space
set softtabstop=2                  " Number of spaces in tab when editing
set shiftwidth=2                   " An autoindent (with <<) is two space
set listchars=tab:»·,trail:·,eol:¬ " Display extra whitespace
set list                           " Always display whitespace
set laststatus=2                   " Always enable status line
set number                         " Show line numers
set numberwidth=2                  " Line numbers max to two digits
set showcmd                        " Show command in bottom bar
set cursorline                     " Highlight current line
set ttyfast                        " Sent more characters because we are on a fast terminal connection
set scrolljump=5                   " Scroll 8 lines at a time at bottom/top
let html_no_rendering=1            " Don't render italic, bold, links in HTML
set showmatch                      " highlight matching [{()}]
set laststatus=2                   " Always show the statusbar
set clipboard=unnamed              " Share Clipboard with OS
set incsearch                      " search as characters are entered
set hlsearch                       " highlight matches
set iskeyword+=-                   " Makes foo-bar considered one word
set lazyredraw
set shell=/bin/zsh

" Refresh files automatically
" http://stackoverflow.com/a/18866818
set autoread
au CursorHold * checktime

" Make directories that not exist on write
func! s:Mkdir()
  let dir = expand('%:p:h')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
    echo 'Created non-existing directory: '.dir
  endif
endfunc
au! BufWritePre * call s:Mkdir()

" Delete trailing white space on save
func! s:DeleteTrailingWhiteSpace()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
au! BufWrite * silent call s:DeleteTrailingWhiteSpace()

au! BufNewFile,BufFilePre,BufRead *.json set ft=javascript " Vim hides quotes for JSON files. This fixes that annoyance

" ---------- PLUGINS

silent! colorscheme gruvbox
let g:gruvbox_termcolors=16
let g:gruvbox_contrast_dark='hard'

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_vimballPlugin = 1

let g:elm_format_autosave = 1

let g:ctrlp_match_window_bottom = 1    " Show at bottom of window
let g:ctrlp_mru_files = 1              " Enable Most Recently Used files feature
let g:ctrlp_use_caching = 0
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 40            " restrict match list to a maxheight of 40
let g:ctrlp_max_files = 0              " no restriction on results/file list
let g:ctrlp_jump_to_buffer = 2         " Jump to tab AND buffer if already open
let g:ctrlp_open_new_file = 'v'        " open selections in a vertical split
let g:ctrlp_open_multiple_files = 'vr' " opens multiple selections in vertical splits to the right

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
endif

nnoremap <Leader>t :CtrlPTag<CR>
nnoremap <Leader>o :CtrlP ./<CR>

nnoremap <Leader>d :Dash<CR>

let g:jsx_ext_required = 0
