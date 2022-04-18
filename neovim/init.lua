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

local format = vim.api.nvim_create_augroup("format", { clear = true })
local formatters = {
	{ "bzl", "buildifier" },
	{ "css", "prettier" },
	{ "html", "prettier" },
	{ "javascript", "prettier" },
	{ "json", "prettier" },
	{ "lua", "stylua" },
	{ "markdown", "prettier" },
	{ "python", "black" },
	{ "scss", "prettier" },
	{ "sql", "pg_format" },
	{ "typescript", "prettier" },
	{ "yaml", "prettier" },
}
for _, f in pairs(formatters) do
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			vim.cmd("set formatprg=" .. f[2])
		end,
		group = format,
		pattern = f[1],
	})
end

local spell = vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.cmd("setlocal spell")
	end,
	group = spell,
	pattern = { "markdown", "text" },
})

local yank = vim.api.nvim_create_augroup("yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = yank,
})

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
					component_separators = "",
					section_separators = "",
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
					lualine_x = {
						"encoding",
						{
							"fileformat",
							symbols = {
								unix = "unix",
								dos = "dos",
								mac = "mac",
							},
						},
						"filetype",
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
				local opts = {}

				if server.name == "sumneko_lua" then
					opts = {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "use", "vim" },
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
								},
							},
						},
					}
				end

				server:setup(opts)
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
end)

vim.api.nvim_create_user_command("ChangeDirectory", "Telescope zoxide list", {})
vim.api.nvim_create_user_command("Reload", "source $MYVIMRC | PackerCompile", {})

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
