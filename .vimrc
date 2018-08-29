set nocompatible

syntax enable

" Clipboard
set clipboard+=unnamed

" Font
set encoding=utf-8
set guifont=SF\ Mono:h14

" Identation
set expandtab
set shiftwidth=2
set softtabstop=2

" Mapping
set backspace=indent,eol,start
set timeoutlen=1000 ttimeoutlen=0

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

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
augroup netrw
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'leafgarland/typescript-vim'
  Plug 'morhetz/gruvbox'
  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-surround'
  Plug 'w0rp/ale'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
call plug#end()

let g:lightline = { 'colorscheme': 'wombat' }

set background=dark
colorscheme gruvbox

let g:ale_sign_error = '✖'

set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
