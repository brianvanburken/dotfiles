call plug#begin()
Plug 'andys8/vim-elm-syntax'
Plug 'ayu-theme/ayu-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', { 'on': ['Ag', 'Buffers', 'Files', 'Tags'] }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'rizzatti/dash.vim', { 'on': 'Dash' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'yggdroot/indentLine'
call plug#end()

set backspace=indent,eol,start
set clipboard=unnamed " Share Clipboard with OS
set colorcolumn=80 " Show column on 80 character for limit reference
set encoding=utf-8 nobomb " Set default encoding to UTF-8
set expandtab " Use spaces not tabs
set hidden " Hide buffers instead of closing them
set hlsearch " highlight matches
set incsearch " search as characters are entered
set iskeyword-=_ " Enable word movement when word contains _
set laststatus=2 " Always enable status line
set lazyredraw
set list " Always display whitespace
set listchars=tab:»·,trail:·,eol:¬,nbsp:_ " Display extra whitespace
set modelines=0 " Don't need modelines and the potential security hazard
set nobackup
set nocompatible
set noerrorbells " Don't beep
set noswapfile
set nowrap " Don't wrap lines
set number " Show line numbers
set numberwidth=2 " Line numbers max to two digits
set regexpengine=1
set scrolloff=5 " Show lines below current line at all times while scrolling
set shiftwidth=2 " An autoindent (with <<) is two space
set showcmd " Show typed command in bottom bar
set smarttab " Insert tabs on the start of a line according to shiftwidth
set softtabstop=2 " Number of spaces in tab when editing
set statusline+=%= " Left/right separator
set statusline+=%c " Cursor column
set statusline+=%h " Help file flag
set statusline+=%l/%L: " Cursor line/total lines
set statusline+=%m " Modified flag
set statusline+=%r " Read only flag
set statusline+=%y " Filetype
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}] " File encoding + format
set statusline=%t " Tail of the filename
set tabstop=2 " A tab is two space
set termencoding=utf-8 " Set encoding to UTF-8
set title " Change the terminal's title
set ttimeoutlen=100
set ttyfast
set viminfo='100,<9999,s100 " Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set visualbell " Don't beep

filetype plugin indent on " Load filetype-specific indent files

let $NVIM_TUI_ENABLE_TRUE_COLOR=1 " This line enables the true color support.
set termguicolors " Enable true colors support

let g:indentLine_setConceal = 0

let g:html_indent_tags = 'li\|p' " Treat <li> and <p> tags like the block tags they are

let g:deoplete#enable_at_startup = 1

let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1

let g:polyglot_disabled = ['elm']

" FZF commands
nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>

nnoremap <Leader>d :Dash<CR>

autocmd BufRead,BufNewFile .envrc set filetype=sh
autocmd BufRead,BufNewFile *.md set filetype=markdown

" Set theme based on macOS Mojave theme
function! SetTheme(...)
  let list = systemlist("defaults read -g AppleInterfaceStyle")
  let mode = empty(list) ? "light" : list[0]
  if mode ==? "dark"
    set background=dark
    let g:ayucolor="dark"
  else
    set background=light
    let g:ayucolor="light"
  endif
  silent! colorscheme ayu
endfunction
call SetTheme()
call timer_start(1000, "SetTheme", {"repeat": -1})

" Set background to none to get correct background when terminal theme is same
" as vim theme.
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
