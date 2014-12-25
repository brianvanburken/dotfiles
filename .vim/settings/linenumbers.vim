set ruler           " Show the cursor position all the time
set numberwidth=2   " Line numbers max to two digits

autocmd FocusLost * :set number
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
"autocmd CursorMoved * :set relativenumber
