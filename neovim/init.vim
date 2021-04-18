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

let g:netrw_banner=0
let g:netrw_liststyle=1
let g:netrw_preview=1

syntax enable
augroup markdownSpell
	autocmd!
	autocmd FileType markdown setlocal spell
	autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

if !isdirectory($HOME . '/.local/share/nvim/site/pack/packer')
	!mkdir -p ~/.local/share/nvim/site/pack/packer
	!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
endif

lua << EOF
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-unimpaired'

  use 'gruvbox-community/gruvbox'
  use 'hoob3rt/lualine.nvim'

  use 'dense-analysis/ale'

  use { 'neovim/nvim-lspconfig', run = 'yarn global add bash-language-server pyright' }
  use 'hrsh7th/nvim-compe'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'vim-test/vim-test'
end)
EOF

" Ale
let g:ale_fix_on_save=1
let g:ale_fixers={}
let g:ale_fixers['*']=['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers.html=['prettier']
let g:ale_fixers.javascript=['prettier', 'eslint']
let g:ale_fixers.json=['prettier']
let g:ale_fixers.markdown=['prettier']
let g:ale_fixers.python=['black']
let g:ale_fixers.sh=['shfmt']
let g:ale_fixers.sql=['pgformatter']
let g:ale_fixers.typescript=['prettier', 'eslint']
let g:ale_fixers.yaml=['prettier']

" Theme
set background=dark
colorscheme gruvbox

augroup yankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

set noshowmode
let g:lualine = {
    \'options' : {
    \  'theme' : 'seoul256',
    \  'section_separators' : [' '],
    \  'component_separators' : [' '],
    \  'icons_enabled' : v:false,
    \},
    \}
lua require("lualine").setup()

" LSP
lua << EOF
require'lspconfig'.bashls.setup{}
require'lspconfig'.denols.setup{
  init_options = {
    lint = true,
  },
}
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
  ensure_installed = {'css', 'html', 'javascript', 'python', 'svelte'},
  highlight = {
    enable = true,
  },
}
EOF

let test#strategy = "neovim"
let test#neovim#term_position = "vertical"

nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

nnoremap <leader>b :Telescope buffers<cr>
nnoremap <leader>c :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>f :Telescope find_files<cr>
nnoremap <leader>g :Telescope live_grep<cr>
" nnoremap <leader>g :!lazygit<cr><cr>
nnoremap <leader>m :marks<cr>
nnoremap <leader>s :split<cr>
nnoremap <leader>q :quit<cr>
nnoremap <leader>ta :Telescope treesitter<cr>
nnoremap <leader>tf :TestFile<cr>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tt :TestNearest<cr>
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>x :edit .<cr>

nnoremap gd :lua vim.lsp.buf.definition()<cr>
nnoremap gi :lua vim.lsp.buf.implementation()<cr>
nnoremap gh :lua vim.lsp.buf.hover()<cr>
nnoremap gr :Telescope lsp_code_actions<cr>
nnoremap gR :lua vim.lsp.buf.rename()<cr>
nnoremap gu :lua vim.lsp.buf.references()<cr>
nnoremap ]d :lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap [d :lua vim.lsp.diagnostic.goto_prev()<cr>

inoremap <f1> :lua vim.lsp.buf.signature_help()<cr>

function KeepInMind()
	echo "vo \t => switch visual end"
	echo "gv \t => last visual"
	echo "zz \t => center"
	echo "J \t => join lines"
	echo "* \t => search word cursor"
	echo "% \t => match parenthesis"
	echo "{ \t => paragraph motion"
	echo ":reg \t => registers"
	echo ":marks \t => marks"
	echo ":g/pattern/command"
	echo "<c-a/x> => increment/decrement"
	echo "q<letter><commands>q => register macro"
	echo "<number>@<letter> => use macro"
	echo ":read !pwd => write output"
endfunction
