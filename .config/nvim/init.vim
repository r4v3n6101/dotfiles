if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ycm-core/YouCompleteMe'
"Plug 'easymotion/vim-easymotion'
"Plug 'terryma/vim-multiple-cursors'
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
set autoindent
set title
set ruler
set novisualbell
set hidden

map <C-n> :NERDTreeToggle<CR>

"Add visual formatting
nmap ,g :YcmCompleter GoTo<CR> 
nmap ,G :YcmCompleter GoToImprecise<CR> 
nmap ,gt :YcmCompleter GoToType<CR>
nmap ,gdc :YcmCompleter GoToDeclaration<CR>
nmap ,gdf :YcmCompleter GoToDefinition<CR>
nmap ,gi :YcmCompleter GoToImplementation<CR>
nmap ,r :YcmRestartServer<CR>
nmap ,f :YcmCompleter FixIt<CR>

let g:ycm_goto_buffer_command = 'new-or-existing-tab'
let g:ycm_disable_for_files_larger_than_kb = 5000
