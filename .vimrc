autocmd!

call plug#begin()

" Language
Plug 'elixir-lang/vim-elixir',  { 'for': ['erlang', 'elixir', 'eelixir'] }
Plug 'elmcast/elm-vim',         { 'for': ['elm'] }
Plug 'othree/html5.vim',        { 'for': ['html', 'eelixir'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }

" Code display
Plug 'ayu-theme/ayu-vim'
Plug 'Yggdroot/indentLine'

" Integrations
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-commentary'

" Interface
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'

" Commands
Plug 'tpope/vim-surround'

call plug#end()

" ---------- SYSTEM
" Toggle highlighted matches
nnoremap <space><space> :nohlsearch<CR>

" Highlight trailing whitespace
match ErrorMsg /\\\@<![\u3000[:space:]]\+$/

filetype indent on                 " Load filetype-specific indent files

let mapleader = " "

set clipboard=unnamed              " Share Clipboard with OS
set colorcolumn=81                 " Show column on 81 character for limit reference
set encoding=utf-8                 " Set default encoding to UTF-8
set expandtab                      " Use spaces not tabs
set hlsearch                       " highlight matches
set incsearch                      " search as characters are entered
set iskeyword+=-                   " Makes foo-bar considered one word
set laststatus=2                   " Always enable status line
set lazyredraw
set list                           " Always display whitespace
set listchars=tab:»·,trail:·,eol:¬ " Display extra whitespace
set nobackup
set noswapfile
set nowrap                         " Set no line wrap
set nowritebackup
set number                         " Show line numers
set numberwidth=2                  " Line numbers max to two digits
set scrolljump=5                   " Scroll 8 lines at a time at bottom/top
set shell=/bin/zsh
set shiftwidth=2                   " An autoindent (with <<) is two space
set showcmd                        " Show command in bottom bar
set showmatch                      " highlight matching [{()}]
set softtabstop=2                  " Number of spaces in tab when editing
set synmaxcol=128                  " Highlight syntax till 128 column
set tabstop=2                      " A tab is two space
set termencoding=utf-8             " Set encoding to UTF-8
set ttyfast                        " Sent more characters because we are on a fast terminal connection
set ttyscroll=3

" Delete trailing white space on save
func! s:DeleteTrailingWhiteSpace()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
au! BufWrite * silent call s:DeleteTrailingWhiteSpace()

au! BufNewFile,BufFilePre,BufRead *.json set ft=javascript " Vim hides quotes for JSON files. This fixes that annoyance

" ---------- PLUGINS
set termguicolors     " enable true colors support
let ayucolor="dark"
silent! colorscheme ayu

" Disable netrw and vimball plugins
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_vimballPlugin = 1
let html_no_rendering = 1 " Don't render italic, bold, links in HTML

let g:elm_format_autosave = 1

let g:ctrlp_jump_to_buffer = 2         " Jump to tab AND buffer if already open
let g:ctrlp_match_window_bottom = 1    " Show at bottom of window
let g:ctrlp_max_files = 0              " no restriction on results/file list
let g:ctrlp_max_height = 40            " restrict match list to a maxheight of 40
let g:ctrlp_mru_files = 1              " Enable Most Recently Used files feature
let g:ctrlp_open_multiple_files = 'vr' " opens multiple selections in vertical splits to the right
let g:ctrlp_open_new_file = 'v'        " open selections in a vertical split
let g:ctrlp_split_window = 0
let g:ctrlp_use_caching = 0

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
endif

nnoremap <Leader>t :CtrlPTag<CR>
nnoremap <Leader>o :CtrlP ./<CR>
