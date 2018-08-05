syntax enable

" Font
set guifont=SF\ Mono:h12
set encoding=utf-8

" Spaces
set tabstop=2
set softtabstop=2
set expandtab

" UI
set number
set showcmd
set cursorline
set wildmenu
set showmatch

" Search
set incsearch
set hlsearch

" vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'https://github.com/w0rp/ale.git'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe'
" Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
call plug#end()

set background=dark
colorscheme gruvbox

let g:lightline = { 'colorscheme': 'wombat' }

autocmd vimenter * NERDTree
let NERDTreeShowHidden=1
