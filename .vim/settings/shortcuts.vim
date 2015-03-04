map <leader>h :noh<CR> " toggle highlighting of search terms


" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Share Clipboard with OS
set clipboard=unnamed
