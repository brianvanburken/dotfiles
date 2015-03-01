let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1

" Ctrl+n to toggle NerdTree
nmap <silent> <C-N> :NERDTreeToggle<CR>

" Close nerdtree when it's the only buffer left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

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
