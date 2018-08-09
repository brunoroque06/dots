set nocompatible

syntax enable

" Font
set encoding=utf-8
set guifont=SF\ Mono:h14

" Identation
set expandtab
set shiftwidth=2
set softtabstop=2

" Search
set ignorecase
set incsearch
set hlsearch
set smartcase

" UI
set cursorline
set lazyredraw
set number
set showcmd
set showmatch
set wildmenu

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'morhetz/gruvbox'
  Plug 'itchyny/lightline.vim'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

set background=dark
colorscheme gruvbox

let g:lightline = { 'colorscheme': 'wombat' }

autocmd vimenter * NERDTree
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

