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
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore

" Ctrl+n to toggle NerdTree
nmap <silent> <C-N> :Rex<CR>
