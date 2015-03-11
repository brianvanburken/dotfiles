autocmd!
let mapleader = ","

" This loads all the plugins specified in ~/.vim/plugins.vim
" Use Vim-plug plugin to manage all other plugins
if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
endif

" Load individual settings configuration files
for fpath in split(globpath('~/.vim/settings', '*.vim'), '\n')
  exe 'source' fpath
endfor
