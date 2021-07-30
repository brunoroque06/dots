vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
vim.g.netrw_preview = 1

vim.o.autoread = true
vim.o.backspace = "indent,eol,start"
vim.o.clipboard = "unnamed"
vim.o.colorcolumn = "120"
vim.o.cursorline = true
vim.o.encoding = "utf-8"
vim.o.grepprg = "rg --vimgrep --hidden --smart-case"
vim.o.hidden = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.incsearch = true
vim.o.mouse = "a"
vim.o.swapfile = false
vim.o.number = true
-- vim.o.path = vim.o.path + '**'
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.showcmd = true
vim.o.smartcase = true
vim.o.termguicolors = true

vim.cmd("syntax enable")
vim.api.nvim_exec(
	[[
augroup markdown_spell
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END
]],
	false
)

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.api.nvim_command("packadd packer.nvim")
end

local packer = require("packer")

packer.init({
	display = {
		open_cmd = "vnew [packer]",
	},
})

packer.startup(function()
	use("wbthomason/packer.nvim")

	use("tpope/vim-commentary")
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("tpope/vim-unimpaired")
	use("tpope/vim-vinegar")

	use("gruvbox-community/gruvbox")
	use("hoob3rt/lualine.nvim")

	use("sbdchd/neoformat")

	use({
		"neovim/nvim-lspconfig",
		run = "npm install -g bash-language-server dockerfile-language-server-nodejs vscode-langservers-extracted pyright",
	})
	use("hrsh7th/nvim-compe")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
	})

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	use("vim-test/vim-test")
end)

-- Theme
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

vim.api.nvim_exec(
	[[
augroup yank_highlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
]],
	false
)

vim.o.showmode = false

require("lualine").setup({
	options = {
		theme = "gruvbox",
	},
})

-- Format
vim.g.neoformat_basic_format_trim = 1
vim.g.shfmt_opt = "-i 0"

vim.api.nvim_exec(
	[[
augroup format
  autocmd!
  autocmd FileType css set formatprg=prettier
  autocmd FileType html set formatprg=prettier
  autocmd FileType javascript set formatprg=prettier
  autocmd FileType json set formatprg=prettier
  autocmd FileType lua set formatprg=stylua
  autocmd FileType markdown set formatprg=prettier
  autocmd FileType python set formatprg=black
  autocmd FileType scss set formatprg=prettier
  autocmd FileType sql set formatprg=pg_format
  autocmd FileType typescript set formatprg=prettier
  autocmd FileType yaml set formatprg=prettier
  autocmd BufWritePre * undojoin | Neoformat
augroup END
]],
	false
)

-- LSP
require("lspconfig").bashls.setup({})
require("lspconfig").denols.setup({
	init_options = {
		lint = true,
	},
})
require("lspconfig").dockerls.setup({})
require("lspconfig").jsonls.setup({})
require("lspconfig").pyright.setup({})

vim.o.completeopt = "menuone,noselect"

require("compe").setup({
	enabled = true,
	autocomplete = true,
	source = {
		path = true,
		buffer = true,
		nvim_lsp = true,
		nvim_lua = true,
		treesitter = true,
	},
})

vim.api.nvim_set_keymap("i", "<c-space>", "compe#complete()", { expr = true, noremap = true })
vim.api.nvim_set_keymap("i", "<cr>", "compe#confirm('<cr>')", { expr = true, noremap = true })
vim.cmd("highlight link CompeDocumentation NormalFloat")

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"css",
		"dockerfile",
		"html",
		"javascript",
		"json",
		"lua",
		"python",
	},
	highlight = {
		enable = true,
	},
})

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vertical"

vim.api.nvim_set_keymap("n", "<leader>a", ":Telescope lsp_code_actions<cr>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>a", ":Telescope lsp_code_actions<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>b", ":Telescope buffers<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>c", ":Telescope commands<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>d", ":lua vim.lsp.buf.definition()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>D", ":lua vim.lsp.buf.declaration()<cr>", { noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>f",
	":lua require('telescope.builtin').find_files({hidden = true})<cr>",
	{ noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>g", ":Telescope live_grep<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>h", ":lua vim.lsp.buf.hover()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>H", ":Telescope help_tags<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>i", ":lua vim.lsp.buf.implementation()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>m", ":Telescope marks<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>p", ":Telescope planets<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":quit<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":lua vim.lsp.buf.rename()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>s", ":split<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":Telescope treesitter<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>u", ":lua vim.lsp.buf.references()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>v", ":vsplit<cr>", { noremap = true })

vim.api.nvim_set_keymap("n", "<c-j>", "<c-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w>l", { noremap = true })
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w>h", { noremap = true })

vim.api.nvim_set_keymap("n", "<bs>", "<c-^>", { noremap = true })

vim.api.nvim_set_keymap("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "[d", ":lua vim.lsp.diagnostic.goto_next()<cr>", { noremap = true })

-- https://github.com/vim/vim/issues/4738
vim.api.nvim_set_keymap(
	"n",
	"gx",
	":call netrw#BrowseX(expand((exists('g:netrw_gx')? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>",
	{ noremap = true }
)

vim.api.nvim_set_keymap("i", "<f1>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { noremap = true })

vim.api.nvim_exec(
	[[
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
]],
	false
)
