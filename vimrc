call plug#begin()

Plug '/usr/local/opt/fzf', { 'on': ['Ag', 'Buffers', 'Files', 'Tags'] }
Plug 'Yggdroot/indentLine'
Plug 'ayu-theme/ayu-vim'
Plug 'brianvanburken/elm-vim', { 'for': ['elm'] } " Change back when to ElmCast/elm-vim if development resumes
Plug 'eagletmt/ghcmod-vim', { 'for': ['haskell']}
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular', { 'on': ['Tab', 'Tabularize'] }
Plug 'junegunn/fzf.vim', { 'on': ['Ag', 'Buffers', 'Files', 'Tags'] }
Plug 'ludovicchabant/vim-gutentags'
Plug 'rizzatti/dash.vim', { 'on': 'Dash' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

call plug#end()

set backspace=indent,eol,start
set clipboard=unnamed              " Share Clipboard with OS
set colorcolumn=80                 " Show column on 80 character for limit reference
set encoding=utf-8 nobomb          " Set default encoding to UTF-8
set expandtab                      " Use spaces not tabs
set hlsearch                       " highlight matches
set incsearch                      " search as characters are entered
set iskeyword-=_                   " Enable word movement when word contains _
set lazyredraw
set list                           " Always display whitespace
set listchars=tab:»·,trail:·,eol:¬,nbsp:_ " Display extra whitespace
set nowrap
set number                         " Show line numers
set numberwidth=2                  " Line numbers max to two digits
set shiftwidth=2                   " An autoindent (with <<) is two space
set showcmd                        " Show typed command in bottom bar
set softtabstop=2                  " Number of spaces in tab when editing
set tabstop=2                      " A tab is two space
set termencoding=utf-8             " Set encoding to UTF-8
set termguicolors
set ttimeoutlen=100
set ttyfast

match Error /\\\@<![\u3000[:space:]]\+$/ " Highlight trailing whitespace

filetype indent on " Load filetype-specific indent files

let ayucolor="dark"
silent! colorscheme ayu

set laststatus=2 " Always enable status line
set statusline=%t " Tail of the filename
set statusline+=%m " Modified flag
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}] " File encoding + format
set statusline+=%h " Help file flag
set statusline+=%r " Read only flag
set statusline+=%y " Filetype
set statusline+=%= " Left/right separator
set statusline+=%l/%L: " Cursor line/total lines
set statusline+=%c " Cursor column

let g:polyglot_disabled = ['elm']

let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 1
let g:elm_detailed_complete = 1

let g:indentLine_setConceal = 0

nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>

nnoremap <Leader>d :Dash<CR>

nnoremap <Leader> tw :GhcModTypeInsert<CR>
nnoremap <Leader> ts :GhcModSplitFunCase<CR>
nnoremap <Leader> tq :GhcModType<CR>
nnoremap <Leader> te :GhcModTypeClear<CR>
