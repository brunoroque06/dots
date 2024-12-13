vim9script

const packs = expand($"{split(&packpath, ",")[0]}/pack/z/start")

def g:PackUninstall()
	confirm($"Deleting {packs}")
	delete(packs, 'rf')
enddef

def g:PackInstall()
	g:PackUninstall()
	mkdir(packs, 'p')
	for p in [
			'sbdchd/neoformat',
			'tpope/vim-commentary',
			'tpope/vim-repeat',
			'tpope/vim-surround',
			'tpope/vim-unimpaired',
			'tpope/vim-vinegar',
			]
		var name = split(p, '/')[1]
		echo $"Installing {p}..."
		silent system($"git clone --depth 1 https://github.com/{p} {packs}/{name}")
	endfor
enddef

filetype plugin indent on
syntax enable

set autoread
set backspace=indent,eol,start
set clipboard=unnamed
set grepprg=rg\ --vimgrep\ --hidden\ --smart-case
set hidden
set lazyredraw
set noswapfile
set splitbelow
set splitright
set wildmenu
set wildmode=longest:list,full

# Search
set hlsearch
set ignorecase
set incsearch
set smartcase

# Spaces
set noexpandtab
set shiftwidth=2
set smarttab
set tabstop=2

# UI
# set list
# set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set mouse=a
set number
set relativenumber
set scrolloff=5
set showcmd
set showmatch
set showmode

g:mapleader = ' '
g:neoformat_basic_format_trim = 1
g:netrw_alto = 0
g:netrw_banner = true
g:netrw_liststyle = 1
g:netrw_preview = 1

cmap <c-p> <up>
cmap <c-n> <down>

nmap == :Neoformat<cr>
nmap U <c-r>
nmap g/ :grep<space>

nmap <leader>j :jumps<cr>
nmap <leader>l :Explore<cr>
nmap <leader>q :q<cr>
nmap <leader>w :w<cr>

autocmd FileType markdown setlocal spell
autocmd FileType sh setlocal makeprg=shellcheck\ -f\ gcc\ %

defcompile

