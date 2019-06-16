if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
call plug#end()

syntax on
set hlsearch
set incsearch
set encoding=utf-8
set number
set mouse=a
set confirm
set autoindent
set title

map <C-o> :NERDTreeToggle<CR>
