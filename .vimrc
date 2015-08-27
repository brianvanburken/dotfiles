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

  let g:ctrlp_use_caching = 0
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](\.(git|hg|svn|bundle)|coverage|dist|tmp|log|bower_components|vendor|node_modules)$',
        \ 'file': '\v\.(swp|zip|DS_Store|jira-url|png|jpg|jpeg|svg|gif|eot|ttf|woff)$'
        \ }
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']

  nnoremap <Leader>o :CtrlP<CR>

  if !has('python')
    echo 'In order to use pymatcher plugin, you need +python compiled vim'
  else
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  endif

  let g:ctrlp_buffer_func = {
      \ 'enter': 'DisableStatusLine',
      \ 'exit':  'EnableStatusLine',
      \ }

  func! DisableStatusLine()
      set laststatus=0
  endfunc

  func! EnableStatusLine()
      set laststatus=2
  endfunc
endif

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

" Define all the different modes
let g:currentmodetext = {
      \ 'n'  : 'NORMAL',
      \ 'no' : 'NORMAL OPERATOR PENDING',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'VISUAL LINE',
      \ '' : 'VISUAL BLOCK',
      \ 's'  : 'SELECT',
      \ 'S'  : 'SELECT Line',
      \ '' : 'SELECT Block',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'REPLACE',
      \ 'Rv' : 'VISUAL REPLACE',
      \ 'c'  : 'COMMAND',
      \ 'cv' : 'VIM EX',
      \ 'ce' : 'EX',
      \ 'r'  : 'PROMPT',
      \ 'rm' : 'MORE',
      \ 'r?' : 'CONFIRM',
      \ '!'  : 'SHELL'
      \}

" Possible choices:
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#cterm-colors
" NR-16   NR-8    COLOR NAME
" 0       0       Black
" 1       4       DarkBlue
" 2       2       DarkGreen
" 3       6       DarkCyan
" 4       1       DarkRed
" 5       5       DarkMagenta
" 6       3       Brown, DarkYellow
" 7       7       LightGray, LightGrey, Gray, Grey
" 8       0*      DarkGray, DarkGrey
" 9       4*      Blue, LightBlue
" 10      2*      Green, LightGreen
" 11      6*      Cyan, LightCyan
" 12      1*      Red, LightRed
" 13      5*      Magenta, LightMagenta
" 14      3*      Yellow, LightYellow
" 15      7*      White
let g:currentmodecolour = {
      \ 'n'  : 'darkgray',
      \ 'no' : 'darkgray',
      \ 'v'  : 'yellow',
      \ 'V'  : 'yellow',
      \ '' : 'yellow',
      \ 's'  : 'yellow',
      \ 'S'  : 'yellow',
      \ '' : 'yellow',
      \ 'i'  : 'green',
      \ 'R'  : 'red',
      \ 'Rv' : 'red',
      \ 'c'  : 'magenta',
      \ 'cv' : 'magenta',
      \ 'ce' : 'magenta',
      \ 'r'  : 'magenta',
      \ 'rm' : 'magenta',
      \ 'r?' : 'magenta',
      \ '!'  : 'magenta'
      \}

" Mode Indication
" Returns mode and sets color based on mode
function! SetStatusLineColor()
  execute 'hi statusline ctermfg='.g:currentmodecolour[mode()]
  return g:currentmodetext[mode()]
endfunction

set laststatus=2 "always enable status line

set statusline=[%{SetStatusLineColor()}]
set statusline+=\       "seperator
set statusline+=%t      "tail of the filename
set statusline+=\       "seperator
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%=      "left/right separator
set statusline+=%h      "help file flag
set statusline+=\       "seperator
set statusline+=[%{strlen(&fenc)?&fenc:'none'}] "file encoding
set statusline+=\       "seperator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines

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
