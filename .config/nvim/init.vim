call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'terryma/vim-multiple-cursors'
"Plug 'tpope/vim-surround'
"Plug 'easymotion/vim-easymotion'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'valloric/youcompleteme'
call plug#end()

syntax on
set hlsearch
set incsearch
set encoding=utf-8
set fileencodings=utf8,cp1251
set nobackup
set noswapfile
set number
set mouse=a
set mousehide
set confirm
set autoindent
set title
set ruler
set novisualbell
set hidden

map <C-o> :NERDTreeToggle<CR>
