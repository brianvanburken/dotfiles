call plug#begin()

" Languages
Plug 'othree/html5.vim', { 'for': ['html', 'php'] }

Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss'] }
Plug 'JulesWang/css.vim', { 'for': ['css', 'scss'] }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'sass'] }

Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'slim-template/vim-slim', { 'for': 'slim' }

Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }

" Code Display
Plug 'morhetz/gruvbox'
Plug 'kien/rainbow_parentheses.vim'

" Intergrations
Plug 'scrooloose/syntastic', { 'for': ['javascript', 'css', 'scss', 'sass', 'ruby'] }
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'osyo-manga/vim-over'
Plug 'mattn/emmet-vim'

" Interface
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'

" Commands
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()
