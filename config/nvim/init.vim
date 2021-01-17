call plug#begin(stdpath('data') . '/plugged')
Plug '/usr/local/opt/fzf', { 'on': ['Ag', 'Files', 'Buffers', 'Tags'] }
Plug 'brglng/ayu-vim', { 'branch': 'feature/set-background' }
" Plug 'ayu-theme/ayu-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf.vim', { 'on': ['Ag', 'Files', 'Buffers'] }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
call plug#end()

syntax on

set background=dark
set backspace=indent,eol,start
set clipboard=unnamed " Share Clipboard with OS
set cmdheight=2
set hidden
set hlsearch " highlight matches
set incsearch " search as characters are entered
set laststatus=2 " Always enable status line
set linebreak
set nobackup
set nowrap
set nowritebackup
set number " Show line numbers
set numberwidth=3 " Line numbers max digits
set scrolloff=5 " Show lines below current line at all times while scrolling
set shortmess+=c " Don't pass messages to |ins-completion-menu|.
set showcmd " Show typed command in bottom bar
set signcolumn=yes
set termguicolors " enable true colors support
set updatetime=300 " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays

set statusline=%t " Tail of the filename
set statusline+=%m " Modified flag
set statusline+=%h " Help file flag
set statusline+=%r " Read only flag
set statusline+=\ %y " Filetype
set statusline+=\[%{&fileencoding?&fileencoding:&encoding}]
set statusline+=%= " Left/right separator
set statusline+=%c:%l/%L " Cursor 'column:line/total'

au BufEnter .envrc setlocal filetype=sh
au BufEnter *.md setlocal filetype=markdown
au BufEnter *.tsx setlocal filetype=typescript.tsx
au FileType gitcommit,markdown setlocal spell

colorscheme ayu

nnoremap <C-a> :Ag!<CR>
nnoremap <C-p> :Files!<CR>
nnoremap <C-t> :Buffers!<CR>

nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

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
call SetBackgroundMode()
call timer_start(5000, "SetBackgroundMode", {"repeat": -1})

" CoC config
let g:coc_global_extensions = [
  \ 'coc-angular',
  \ 'coc-css',
  \ 'coc-elixir',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-snippets',
  \ 'coc-stylelint',
  \ 'coc-tslint',
  \ 'coc-tsserver',
  \ ]

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Format code on save
command! -nargs=0 Prettier :CocCommand prettier.formatFile

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>f <Plug>CocAction('format')<CR>
nmap <leader>o <Plug>CocAction('runCommand', 'editor.action.organizeImport')<CR>
