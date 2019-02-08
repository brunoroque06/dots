set nocompatible

" Buffers
set hidden
nnoremap gb :ls<CR>:b<Space>

" Clipboard
set clipboard^=unnamed,unnamedplus

" Files
set autoread
set path+=**
set noswapfile

" Indentation
set expandtab
set shiftwidth=2
set softtabstop=2

" Mapping
set backspace=indent,eol,start
set ttimeoutlen=0

" Mouse
set ttymouse=xterm2
set mouse=a

" Search
set ignorecase
set incsearch
set hlsearch
set smartcase

" Text
syntax enable
set encoding=utf-8
augroup markdownSpell
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

" UI
set cursorline
set laststatus=2
set lazyredraw
set noshowmode
set number
set scrolloff=10
set showcmd
set wildmenu

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'ervandew/supertab'
Plug 'itchyny/lightline.vim'
let g:lightline = { 'colorscheme': 'wombat' }
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
let g:ale_fix_on_save = 1
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier']
let g:ale_sign_error = '✖'
call plug#end()

set background=dark
colorscheme gruvbox
highlight SpellBad cterm=underline ctermfg=DarkRed gui=underline guifg=DarkRed
