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

" Don't display these kinds of files
let NERDTreeIgnore = [
      \ '\.git$',
      \ '\.DS_Store',
      \ 'bin$',
      \ 'node_modules$',
      \ 'bower_components$',
      \ 'coverage$',
      \ 'tmp$',
      \ 'log$',
      \ 'dist$']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|bin$\|node_modules$\|bower_components$\|coverage$\|tmp$\|log$\|dist$',
  \ 'file': '\.DS_Store$' }
