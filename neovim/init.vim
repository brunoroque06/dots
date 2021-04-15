set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

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

function Pack() abort
	if isdirectory('~/.vim/pack/minpac')
		!mkdir -p ~/.vim/pack/minpac/opt/minpac
		!git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
	endif

	packadd minpac

	call minpac#init()
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	call minpac#add('tpope/vim-commentary')
	call minpac#add('tpope/vim-surround')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('tpope/vim-unimpaired')

	call minpac#add('gruvbox-community/gruvbox')
	call minpac#add('hoob3rt/lualine.nvim')

	call minpac#add('dense-analysis/ale')

	call minpac#add('neovim/nvim-lspconfig')
	call minpac#add('hrsh7th/nvim-compe')

	call minpac#add('nvim-lua/popup.nvim')
	call minpac#add('nvim-lua/plenary.nvim')
	call minpac#add('nvim-telescope/telescope.nvim')

	call minpac#add('nvim-treesitter/nvim-treesitter')

	call minpac#add('vim-test/vim-test')

	call minpac#update()
	call minpac#clean()
endfunction

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

augroup LuaHighlight
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

" lua <<EOF
" require('telescope').setup{
"   defaults = {
"     vimgrep_arguments = {
"       'rg',
"       '--color=never',
"       '--no-heading',
"       '--with-filename',
"       '--line-number',
"       '--column',
"       '--smart-case',
"       '--hidden'
"     },
"   }
" }
" EOF

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

nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>c <cmd>source ~/.vim/vimrc<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope grep_string<cr>
" nnoremap <leader>g <cmd>!lazygit<cr><cr>
nnoremap <leader>m <cmd>marks<cr>
nnoremap <leader>s <cmd>split<cr>
nnoremap <leader>q <cmd>quit<cr>
nnoremap <leader>ta <cmd>Telescope treesitter<cr>
nnoremap <leader>tf <cmd>TestFile<cr>
nnoremap <leader>tl <cmd>TestLast<CR>
nnoremap <leader>ts <cmd>TestSuite<CR>
nnoremap <leader>tt <cmd>TestNearest<cr>
nnoremap <leader>v <cmd>vsplit<cr>
nnoremap <leader>x <cmd>edit .<cr>

nnoremap gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap gi <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap gh <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap gr <cmd>Telescope lsp_code_actions<cr>
nnoremap gR <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap gu <cmd>lua vim.lsp.buf.references()<cr>
nnoremap ]d <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap [d <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>

inoremap <f1> <cmd>lua vim.lsp.buf.signature_help()<cr>

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
