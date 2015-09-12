call plug#begin()

" Languages
Plug 'othree/html5.vim',             { 'for': ['html', 'php'] }
Plug 'hail2u/vim-css3-syntax',       { 'for': ['css', 'scss'] }
Plug 'JulesWang/css.vim',            { 'for': ['css', 'scss'] }
Plug 'cakebaker/scss-syntax.vim',    { 'for': 'scss' }
Plug 'ap/vim-css-color',             { 'for': ['css', 'scss', 'sass'] }
Plug 'vim-ruby/vim-ruby',            { 'for': 'ruby' }
Plug 'tpope/vim-rails',              { 'for': 'ruby' }
Plug 'slim-template/vim-slim',       { 'for': 'slim' }
Plug 'keith/rspec.vim',              { 'for': 'ruby' }
Plug 'pangloss/vim-javascript',      { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'tpope/vim-cucumber',           { 'for': ['ruby', 'cucumber'] }
Plug 'elixir-lang/vim-elixir',       { 'for': ['erlang', 'elixir'] }

" Code Display
Plug 'morhetz/gruvbox'
Plug 'kien/rainbow_parentheses.vim'

" Intergrations
Plug 'scrooloose/syntastic', { 'for': ['javascript', 'css', 'scss', 'sass', 'ruby'] }
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'osyo-manga/vim-over'

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

" Interface
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'unblevable/quick-scope'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'terryma/vim-expand-region'
Plug 'junegunn/vim-easy-align'

" Commands
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()
