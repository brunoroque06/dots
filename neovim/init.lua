vim.g.mapleader = " "
vim.g.netrw_banner = true
vim.g.netrw_liststyle = 1
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0

vim.o.autoread = true
vim.o.backspace = "indent,eol,start"
vim.o.clipboard = "unnamed"
vim.o.colorcolumn = "120"
vim.o.cursorline = true
vim.o.encoding = "utf-8"
vim.o.fileformat = "unix"
vim.o.grepprg = "rg --vimgrep --hidden --smart-case"
vim.o.hidden = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.incsearch = true
vim.o.list = true
vim.o.listchars = "eol:↵,nbsp:␣,tab:> ,trail:~"
vim.o.mouse = "a"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 8
vim.o.showcmd = true
vim.o.showmode = false
vim.o.smartcase = true
vim.o.termguicolors = true

vim.cmd("syntax enable")
vim.api.nvim_exec(
	[[
augroup markdown_spell
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup end
]],
	false
)

vim.api.nvim_exec(
	[[
augroup yank_highlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup end
]],
	false
)

vim.api.nvim_exec(
	[[
augroup elvish
  autocmd!
  autocmd BufNewFile,BufRead *.elv set filetype=elvish
augroup end
]],
	false
)

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.api.nvim_command("packadd packer.nvim")
end

local packer = require("packer")

packer.init({ display = { open_cmd = "vnew \\[packer\\]" } })

packer.startup(function()
	use("wbthomason/packer.nvim")

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("tpope/vim-unimpaired")
	use("tpope/vim-vinegar")

	use({
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").load()
		end,
	})

	use({
		"hoob3rt/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					component_separators = { "", "" },
					section_separators = { "", "" },
					theme = "kanagawa",
				},
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true,
							path = 1,
						},
					},
				},
			})
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	})
	use({
		"projekt0n/circles.nvim",
		requires = { { "kyazdani42/nvim-web-devicons" } },
		config = function()
			require("circles").setup()
		end,
	})

	use({
		"sbdchd/neoformat",
		config = function()
			vim.g.neoformat_basic_format_trim = 1
			vim.g.shfmt_opt = "-i 0"

			-- https://github.com/sbdchd/neoformat/issues/134#issuecomment-347180213
			vim.api.nvim_exec(
				[[
				augroup format
				  autocmd!
				  autocmd FileType bzl set formatprg=buildifier
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
				augroup END
				]],
				false
			)
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		requires = { "williamboman/nvim-lsp-installer" },
		run = function()
			local servers = {
				"bashls",
				"dockerls",
				"jsonls",
				"pyright",
				"sumneko_lua",
				"tsserver",
				"yamlls",
			}

			for _, server in pairs(servers) do
				local _, s = require("nvim-lsp-installer").get_server(server)
				s:install()
			end
		end,
		config = function()
			require("nvim-lsp-installer").on_server_ready(function(server)
				server:setup({})
			end)
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip" },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				formatting = {
					format = function(entry, vim_item)
						vim_item.menu = ({
							buffer = "[B]",
							nvim_lsp = "[L]",
							nvim_lua = "[N]",
							path = "[P]",
						})[entry.source.name]
						return vim_item
					end,
				},
				mapping = {
					["<c-p>"] = cmp.mapping.select_prev_item(),
					["<c-n>"] = cmp.mapping.select_next_item(),
					["<c-space>"] = cmp.mapping.complete(),
					["<c-e>"] = cmp.mapping.close(),
					["<cr>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
				},
				sources = {
					{ name = "buffer" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "path" },
				},
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
			})
		end,
	})
	use("github/copilot.vim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "jvgrootveld/telescope-zoxide" },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("zoxide")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		requires = { "p00f/nvim-ts-rainbow" },
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"css",
					"dockerfile",
					"fish",
					"elvish",
					"html",
					"javascript",
					"json",
					"lua",
					"python",
					"typescript",
					"yaml",
				},
				highlight = {
					enable = true,
				},
				rainbow = {
					enable = false,
				},
			})
		end,
	})

	use({
		"vim-test/vim-test",
		config = function()
			vim.g["test#strategy"] = "neovim"
			vim.g["test#neovim#term_position"] = "vertical"
		end,
	})

	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup({ kind = "tab" })
		end,
	})
end)

vim.api.nvim_exec("command! ChangeDirectory Telescope zoxide list", false)
vim.api.nvim_exec("command! Reload source $MYVIMRC | PackerCompile", false)

vim.keymap.set("i", "<f1>", vim.lsp.buf.signature_help)

vim.keymap.set("n", "==", ":Neoformat<cr>")
vim.keymap.set("n", "[d", vim.lsp.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.lsp.diagnostic.goto_next)
vim.keymap.set("n", "ga", ":Telescope lsp_code_actions<cr>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.rename)
vim.keymap.set("n", "gs", ":Telescope treesitter<cr>")
vim.keymap.set("n", "gu", ":Telescope lsp_references<cr>")

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")

local keybinds = vim.fn.stdpath("config") .. "/keybinds.lua"
vim.cmd("source " .. keybinds)
