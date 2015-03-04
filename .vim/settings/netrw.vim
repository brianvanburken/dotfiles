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
nmap <silent> <C-N> :Rex<CR>
