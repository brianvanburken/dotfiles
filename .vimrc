call plug#begin()
" Language
Plug 'elixir-lang/vim-elixir',  { 'for': ['erlang', 'elixir', 'eelixir'] }
Plug 'elmcast/elm-vim',         { 'for': ['elm'] }
Plug 'othree/html5.vim',        { 'for': ['html', 'eelixir'] }
Plug 'pangloss/vim-javascript', { 'for': ['html', 'eelixir', 'javascript'] }

" Code display
Plug 'ayu-theme/ayu-vim'
Plug 'Yggdroot/indentLine'

" Integrations
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
Plug 'rizzatti/dash.vim'

" Interface
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'

" Commands
Plug 'tpope/vim-surround'

call plug#end()

" ---------- SYSTEM
set clipboard=unnamed              " Share Clipboard with OS
set colorcolumn=80                 " Show column on 80 character for limit reference
set encoding=utf-8 nobomb          " Set default encoding to UTF-8
set expandtab                      " Use spaces not tabs
set hlsearch                       " highlight matches
set incsearch                      " search as characters are entered
set laststatus=2                   " Always enable status line
set list                           " Always display whitespace
set listchars=tab:»·,trail:·,eol:¬,nbsp:_ " Display extra whitespace
set nobackup
set noswapfile
set nowritebackup
set number                         " Show line numers
set numberwidth=2                  " Line numbers max to two digits
set shiftwidth=2                   " An autoindent (with <<) is two space
set showcmd                        " Show typed command in bottom bar
set showmatch                      " highlight matching [{()}]
set softtabstop=2                  " Number of spaces in tab when editing
set tabstop=2                      " A tab is two space
set termencoding=utf-8             " Set encoding to UTF-8
set termguicolors
set ttyfast

" ---------- OTHER
" Highlight trailing whitespace
match ErrorMsg /\\\@<![\u3000[:space:]]\+$/

filetype indent on " Load filetype-specific indent files

let ayucolor="dark"
silent! colorscheme ayu

let html_no_rendering = 1 " Don't render italic, bold, links in HTML

let g:javascript_plugin_jsdoc = 1

let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 1

nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>

nnoremap <Leader>d :Dash<CR>

augroup file_types
  " Treat .json files as JavaScript (Vim hides quotes for JSON files)
  au! BufNewFile,BufFilePre,BufRead *.json setlocal filetype=javascript
  au! BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown
augroup END

augroup elm
  au!
  au BufNewFile,BufRead *.elm setlocal tabstop=4
  au BufNewFile,BufRead *.elm setlocal shiftwidth=4
  au BufNewFile,BufRead *.elm setlocal softtabstop=4
augroup END
