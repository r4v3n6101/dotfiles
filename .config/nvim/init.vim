if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'easymotion/vim-easymotion'
"Plug 'terryma/vim-multiple-cursors'
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
