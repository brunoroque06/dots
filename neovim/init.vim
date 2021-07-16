set autoread
set backspace=indent,eol,start
set clipboard=unnamed
set colorcolumn=120
set cursorline
set encoding=utf-8
set grepprg=rg\ --vimgrep\ --hidden\ --smart-case
set hidden
set hlsearch
set ignorecase
set inccommand=nosplit
set incsearch
set mouse=a
set nocompatible
set noswapfile
set number
set path+=**
set relativenumber
set scrolloff=8
set showcmd
set smartcase
set termguicolors

let g:netrw_banner=0
let g:netrw_liststyle=1
let g:netrw_preview=1

syntax enable
augroup markdown_spell
	autocmd!
	autocmd FileType markdown setlocal spell
	autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

if !isdirectory($HOME . '/.local/share/nvim/site/pack/packer')
	!mkdir -p ~/.local/share/nvim/site/pack/packer
	!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
endif

lua << EOF
local packer = require'packer'

packer.init({
display = {
	open_cmd = 'vnew [packer]',
	}
})

packer.startup(function()
use 'wbthomason/packer.nvim'

use 'tpope/vim-commentary'
use 'tpope/vim-repeat'
use 'tpope/vim-surround'
use 'tpope/vim-unimpaired'
use 'tpope/vim-vinegar'

use 'gruvbox-community/gruvbox'
use 'hoob3rt/lualine.nvim'

use 'sbdchd/neoformat'

use { 'neovim/nvim-lspconfig', run = 'npm install -g bash-language-server vscode-langservers-extracted pyright' }
use 'hrsh7th/nvim-compe'

use {
	'nvim-telescope/telescope.nvim',
	requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

use 'vim-test/vim-test'
end)
EOF

" Theme
set background=dark
colorscheme gruvbox

augroup yank_highlight
	autocmd!
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

set noshowmode
lua << EOF
require'lualine'.setup{
options = {
	theme = 'seoul256',
	component_separators = {''},
	section_separators = {''},
	}
}
EOF

" Format
autocmd FileType css set formatprg=prettier
autocmd FileType html set formatprg=prettier
autocmd FileType javascript set formatprg=prettier
autocmd FileType json set formatprg=prettier
autocmd FileType markdown set formatprg=prettier
autocmd FileType python set formatprg=black
autocmd FileType scss set formatprg=prettier
autocmd FileType sql set formatprg=pg_format
autocmd FileType typescript set formatprg=prettier
autocmd FileType yaml set formatprg=prettier

let g:neoformat_basic_format_trim = 1

" autocmd! FileType sh set shiftwidth=0
let g:shfmt_opt="-i 0"

augroup format
	autocmd!
	autocmd BufWritePre * undojoin | Neoformat
augroup END

" LSP
lua << EOF
require'lspconfig'.bashls.setup{}
require'lspconfig'.denols.setup{
init_options = {
	lint = true,
	},
}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.pyright.setup{}
EOF

set completeopt=menuone,noselect
lua << EOF
require'compe'.setup {
enabled = true;
autocomplete = true;
source = {
	path = true;
	buffer = true;
	nvim_lsp = true;
	nvim_lua = true;
	treesitter = true;
	};
}
EOF
inoremap <expr> <c-space> compe#complete()
inoremap <expr> <cr> compe#confirm('<cr>')
highlight link CompeDocumentation NormalFloat

lua <<EOF
require'nvim-treesitter.configs'.setup {
ensure_installed = {
	'bash',
	'css',
	'html',
	'javascript',
	'json',
	'lua',
	'python',
	'svelte'
	},
highlight = {
enable = true,
},
}
EOF

let test#strategy = "neovim"
let test#neovim#term_position = "vertical"

nnoremap <leader>a :Telescope lsp_code_actions<cr>
nnoremap <leader>b :Telescope buffers<cr>
nnoremap <leader>c :Telescope commands<cr>
nnoremap <leader>d :lua vim.lsp.buf.definition()<cr>
nnoremap <leader>D :lua vim.lsp.buf.declaration()<cr>
nnoremap <leader>f :lua require('telescope.builtin').find_files({hidden = true})<cr>
nnoremap <leader>g :Telescope live_grep<cr>
nnoremap <leader>h :lua vim.lsp.buf.hover()<cr>
nnoremap <leader>H :Telescope help_tags<cr>
nnoremap <leader>i :lua vim.lsp.buf.implementation()<cr>
nnoremap <leader>m :Telescope marks<cr>
nnoremap <leader>p :Telescope planets<cr>
nnoremap <leader>q :quit<cr>
nnoremap <leader>r :lua vim.lsp.buf.rename()<cr>
nnoremap <leader>s :split<cr>
nnoremap <leader>t :Telescope treesitter<cr>
nnoremap <leader>u :lua vim.lsp.buf.references()<cr>
nnoremap <leader>v :vsplit<cr>

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

nnoremap <bs> <c-^>

nnoremap [d :lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap ]d :lua vim.lsp.diagnostic.goto_next()<cr>

" https://github.com/vim/vim/issues/4738
nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>

inoremap <f1> <cmd>lua vim.lsp.buf.signature_help()<cr>

function! KeepInMind()
	echo "# Command"
	echo "q:"

	echo "\n# Edit"
	echo ":reg"
	echo "J \t => join lines"
	echo "<c-a/x> \t => increment/decrement"
	echo "q<letter><commands>q \t => register macro"
	echo "<number>@<letter> \t => use macro"
	echo ":g/pattern/command"
	echo ":read !pwd \t => write output"

	echo "\n# Motion"
	echo "ge => be"
	echo ":changes"
	echo "g; => p change"
	echo "g, => n change"
	echo ":jumps"
	echo "c-o \t => p jump"
	echo "c-i \t => n jump"
	echo "c-s-6 \t => switch files"
	echo "`` '' \t => switch jump"
	echo ":marks"
	echo "zz \t => center"
	echo "* \t => search word cursor"
	echo "% \t => match parenthesis"
	echo "{ \t => paragraph"
	echo "( \t => sentence"

	echo "\n# Split"
	echo "<c-w>JLHK => move splits"
	echo "<c-w>= => even splits"

	echo "\n# Visual"
	echo "gv \t => last visual"
	echo "o \t => switch visual end"
	echo "vab \t => block ()"
	echo "vaB \t => block {}"
	echo "> \t => shift text"
	echo "\n"
endfunction
