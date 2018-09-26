set nocompatible

" Clipboard
set clipboard+=unnamed

" Files
set autoread
set path+=**

" Indentation
set expandtab
set shiftwidth=2
set softtabstop=2
augroup autoindent
  au!
  autocmd BufWritePre * :normal migg=G`i
augroup End

" Mapping
set backspace=indent,eol,start
set timeoutlen=1000 ttimeoutlen=0

" Mouse
set ttymouse=xterm2
set mouse=a

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

" Search
set ignorecase
set incsearch
set hlsearch
set smartcase

" Text
syntax enable
set encoding=utf-8
set guifont=SF\ Mono:h14
augroup markdownSpell
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

" UI
set cursorline
set lazyredraw
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
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-surround'

Plug 'fatih/vim-go'
Plug 'tmux-plugins/vim-tmux'

Plug 'w0rp/ale'
call plug#end()

let g:lightline = { 'colorscheme': 'wombat' }

set background=dark
colorscheme gruvbox
highlight SpellBad cterm=underline ctermfg=DarkRed gui=underline guifg=DarkRed

let g:ale_fix_on_save = 1
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier']
let g:ale_sign_error = '✖'

