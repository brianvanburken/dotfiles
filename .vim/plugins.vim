call plug#begin()

" Languages
Plug 'othree/html5.vim', { 'for': ['html', 'php'] }
Plug 'mustache/vim-mustache-handlebars', { 'for': ['html', 'htmlbars', 'handlebars'] }

Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss'] }
Plug 'JulesWang/css.vim', { 'for': ['css', 'scss'] }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'sass'] }

Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'slim-template/vim-slim', { 'for': 'slim' }

Plug 'dsawardekar/ember.vim', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }

" Autocompletion
" Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'marijnh/tern_for_vim'

" Code Display
Plug 'morhetz/gruvbox'
Plug 'kien/rainbow_parentheses.vim'

" Intergrations
Plug 'scrooloose/syntastic', { 'for': ['javascript', 'css', 'scss', 'sass', 'ruby'] }
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'osyo-manga/vim-over'

" Interface
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
" Plug 'scrooloose/nerdtree'
" Plug 'bling/vim-airline'

" Commands
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()
