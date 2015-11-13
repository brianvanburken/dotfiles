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
Plug 'keith/rspec.vim',                        { 'for': 'ruby' }
Plug 'tpope/vim-cucumber',                     { 'for': ['ruby', 'cucumber'] }
Plug 'slim-template/vim-slim',                 { 'for': 'slim' }

Plug 'pangloss/vim-javascript',                { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax',           { 'for': 'javascript' }
Plug 'moll/vim-node',                          { 'for': 'javascript' }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }

Plug 'elixir-lang/vim-elixir',                 { 'for': ['erlang', 'elixir'] }
Plug 'avdgaag/vim-phoenix',                    { 'for': ['erlang', 'elixir'] }

" Code Display
Plug 'morhetz/gruvbox'
Plug 'kien/rainbow_parentheses.vim'

" Intergrations
Plug 'scrooloose/syntastic', { 'for': ['javascript', 'css', 'scss', 'sass', 'ruby'] }
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'osyo-manga/vim-over'

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

Plug 'rizzatti/dash.vim'
Plug 'editorconfig/editorconfig-vim'

" Interface
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-expand-region'
Plug 'unblevable/quick-scope'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'

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

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

set termencoding=utf-8
set encoding=utf-8      " Set default encoding to UTF-8
set colorcolumn=80

" CtrlP
let g:ctrlp_match_window_bottom = 1    " Show at bottom of window
let g:ctrlp_mru_files = 1              " Enable Most Recently Used files feature
let g:ctrlp_use_caching = 0
let g:ctrlp_showhidden = 1             " do not show hidden files in match list
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 40            " restrict match list to a maxheight of 40
let g:ctrlp_use_caching = 0            " don't cache, we want new list immediately each time
let g:ctrlp_max_files = 0              " no restriction on results/file list
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|bundle)|coverage|dist|tmp|log|bower_components|vendor|node_modules|_build|deps)$',
  \ 'file': '\v\.(swp|DS_Store|png|jpg|jpeg|ico|svg|gif|eot|ttf|woff)$'
  \ }

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>p :CtrlP<CR>

" Dash.app
nnoremap <Leader>d :Dash<CR>

" Force the use of Vim movement
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" <leader>+n to toggle NerdTree
nnoremap <Leader>n :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeIgnore = [
      \ '\.git$',
      \ '\.DS_Store',
      \ 'bin$',
      \ 'node_modules$',
      \ 'bower_components$',
      \ 'coverage$',
      \ 'tmp$',
      \ 'log$',
      \ 'dist$',
      \ '_build$',
      \ 'deps$' ]


set incsearch           " search as characters are entered
set hlsearch            " highlight matches
nnoremap <leader><space> :nohlsearch<CR>
" Vim will keep highlighted matches from searches until you either run a new
" one or manually stop highlighting the old search with :nohlsearch. I find
" myself running this all the time so I've mapped it to ,<space>.

" Rainbow-parenthsis
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


" Highlight trailing whitespace
match ErrorMsg '\s\s+%'

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

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

" Set gruvbox contrast
let g:gruvbox_contrast_dark='hard'
