autocmd!

call plug#begin()

" Languages
Plug 'othree/html5.vim',                       { 'for': 'html' }

Plug 'cakebaker/scss-syntax.vim',              { 'for': 'scss' }
Plug 'hail2u/vim-css3-syntax',                 { 'for': ['css', 'scss'] }
Plug 'JulesWang/css.vim',                      { 'for': ['css', 'scss'] }
Plug 'ap/vim-css-color',                       { 'for': ['css', 'scss'] }

Plug 'vim-ruby/vim-ruby',                      { 'for': 'ruby' }
Plug 'tpope/vim-rails',                        { 'for': 'ruby' }
Plug 'slim-template/vim-slim',                 { 'for': 'slim' }

Plug 'pangloss/vim-javascript',                { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax',           { 'for': 'javascript' }
Plug 'moll/vim-node',                          { 'for': 'javascript' }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }

Plug 'elixir-lang/vim-elixir',                 { 'for': ['erlang', 'elixir'] }
Plug 'avdgaag/vim-phoenix',                    { 'for': ['erlang', 'elixir'] }

" Code Display
Plug 'morhetz/gruvbox'

" Intergrations
Plug 'airblade/vim-gitgutter'
Plug 'osyo-manga/vim-over'

Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'tomtom/tlib_vim' | Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

Plug 'rizzatti/dash.vim'
Plug 'editorconfig/editorconfig-vim'

" Interface
Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-expand-region'

Plug 'unblevable/quick-scope'
Plug 'itchyny/lightline.vim'

" Commands
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

let mapleader = " "

"" Backup and swap files
set noswapfile
set nowritebackup
set nobackup

set t_Co=256
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

set termencoding=utf-8
set encoding=utf-8      " Set default encoding to UTF-8
set colorcolumn=80

" CtrlP
let g:ctrlp_match_window_bottom = 1    " Show at bottom of window
let g:ctrlp_mru_files = 1              " Enable Most Recently Used files feature
let g:ctrlp_use_caching = 0
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 40            " restrict match list to a maxheight of 40
let g:ctrlp_max_files = 0              " no restriction on results/file list

if executable('ag')
  " Use Ag over Grep
  " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
endif

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>p :CtrlP<CR>
" the next line is to force CtrlP instead of NERDTree because of memory muscle
nnoremap <Leader>n :CtrlP<CR>

" Dash.app
nnoremap <Leader>d :Dash<CR>

" Force the use of Vim movement
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Easier split navigations
" https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally#easier-split-navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Create window splits easier.
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" More natural split opening
" https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally#more-natural-split-opening
set splitbelow
set splitright

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
nnoremap <leader><space> :nohlsearch<CR>
" Vim will keep highlighted matches from searches until you either run a new
" one or manually stop highlighting the old search with :nohlsearch. I find
" myself running this all the time so I've mapped it to ,<space>.

" Highlight trailing whitespace
match ErrorMsg /\s\+$/

set nowrap                          " Set no line wrap
set expandtab                       " Use spaces not tabs
set tabstop=2                       " A tab is two space
set softtabstop=2                   " Number of spaces in tab when editing
set shiftwidth=2                    " An autoindent (with <<) is two space
set listchars=tab:»·,trail:·,eol:¬  " Display extra whitespace
set list                            " Always display whitespace
set laststatus=2                    " Always enable status line
set number                          " Show line numers
set numberwidth=2                   " Line numbers max to two digits
set showcmd                         " Show command in bottom bar
set cursorline                      " Highlight current line
filetype indent on                  " Load filetype-specific indent files
set lazyredraw                      " Redraw only when we need to.
" Vim loves to redraw the screen during things it probably doesn't need to—like
" in the middle of macros. This tells Vim not to bother redrawing during these
" scenarios, leading to faster macros.
set showmatch        " highlight matching [{()}]
set laststatus=2     " Always show the statusbar
set clipboard=unnamed " Share Clipboard with OS
" set so=7 " Set 7 lines to the cursor - when moving vertically using j/

function! VisualFindAndReplace()
    :OverCommandLine%s/
    :w
endfunction

function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
    :w
endfunction

nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>

" Switching between buffers
nnoremap <Leader>bn :bn<cr> " Next buffer
nnoremap <Leader>bp :bp<cr> " Previous buffer
nnoremap <Leader>bd :bd<cr> " Buffer delete
