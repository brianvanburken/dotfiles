autocmd!
let mapleader = " "

" This loads all the plugins specified in ~/.vim/plugins.vim
" Use Vim-plug plugin to manage all other plugins
if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
endif

"" Backup and swap files
" http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set noswapfile
set nowritebackup
set nobackup
set viminfo=

" Disable netrw history
let g:netrw_dirhistmax = 0

set background=dark
colorscheme gruvbox

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

set termencoding=utf-8
set encoding=utf-8      " Set default encoding to UTF-8
set colorcolumn=80

" CtrlP
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif
let g:ctrlp_match_window_bottom = 1    " Show at bottom of window
let g:ctrlp_mru_files = 1              " Enable Most Recently Used files feature
let g:ctrlp_use_caching = 0
let g:ctrlp_showhidden = 0             " do not show hidden files in match list
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 40            " restrict match list to a maxheight of 40
let g:ctrlp_use_caching = 0            " don't cache, we want new list immediately each time
let g:ctrlp_max_files = 0              " no restriction on results/file list
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.(git|hg|svn|bundle)|coverage|dist|tmp|log|bower_components|vendor|node_modules)$',
      \ 'file': '\v\.(swp|DS_Store|png|jpg|jpeg|ico|svg|gif|eot|ttf|woff)$'
      \ }

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>p :CtrlP<CR>

if !has('python')
  echo 'In order to use pymatcher plugin, you need +python compiled vim'
else
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols = {}
let g:airline#extensions#branch = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 0

" No need for pressing shift
nnoremap ; :

" Force the use of Vim movement
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Quicker navigation between panes
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <Leader>w <C-w>w<CR>
nnoremap <Leader>wv <C-w>v<CR>
nnoremap <Leader>ws <C-w>s<CR>

" Yank till end
nnoremap Y y$

" Use w!! to save a file with privileges if forgotten to sudo it
cmap w!! w !sudo tee % >/dev/null

" Exclude files from autocomplete
set wildignore += "*/.git/*"
set wildignore += "*/.DS_Store"
set wildignore += "*/bin/*"
set wildignore += "*/node_modules/*"
set wildignore += "*/bower_components/*"
set wildignore += "*/coverage/*"
set wildignore += "*/tmp/*"
set wildignore += "*/log/*"
set wildignore += "*/dist/*"

let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 0
let g:netrw_banner = 1
let g:netrw_list_hide = '.git/,.DS_Store,tmp/,node_modules/,bower_components/,bin/,dist/,log/'
let g:netrw_localrmdir='rm -r'
let g:netrw_dirhistmax = 0 " Disable .netrwhist/.netrwbook

" Ctrl+n to toggle NerdTree
" nmap <silent> <C-N> :Rex<CR>
nnoremap <Leader>n :Rexplore<CR>

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

" Automatic removal of trailing whitespaces
autocmd FileType * autocmd BufWritePre <buffer> StripWhitespace

set nowrap                          " Set no line wrap
set expandtab                       " Use spaces not tabs
set tabstop=2                       " A tab is two space
set softtabstop=2                   " Number of spaces in tab when editing
set shiftwidth=2                    " An autoindent (with <<) is two space
set listchars=tab:»·,trail:·,eol:¬  " Display extra whitespace
set list                            " Always display whitespace

set laststatus=2 "always enable status line

set number          " Show line numers
set numberwidth=2   " Line numbers max to two digits
set showcmd         " show command in bottom bar
set cursorline      " highlight current line
filetype indent on  " load filetype-specific indent files
set lazyredraw          " redraw only when we need to.
" Vim loves to redraw the screen during things it probably doesn't need to—like
" in the middle of macros. This tells Vim not to bother redrawing during these
" scenarios, leading to faster macros.
set showmatch        " highlight matching [{()}]
set laststatus=2     " Always show the statusbar
set clipboard=unnamed " Share Clipboard with OS
set so=7 " Set 7 lines to the cursor - when moving vertically using j/

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
