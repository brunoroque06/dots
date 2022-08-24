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
vim.o.tabstop = 4
vim.o.termguicolors = true

vim.cmd("syntax enable")

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

packer.init({ display = { open_cmd = "tabnew \\[packer\\]" } })

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
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"mcchrish/zenbones.nvim",
		requires = { "rktjmp/lush.nvim" },
		config = function()
			vim.cmd("colorscheme zenbones")
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		event = "ColorScheme",
		config = function()
			require("lualine").setup({
				options = {
					component_separators = "",
					section_separators = "",
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
						},
						"filetype",
					},
				},
			})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		event = "ColorScheme",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({
		"mhartington/formatter.nvim",
		config = function()
			local prettier = function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					["*"] = {
						function()
							return {
								exe = "elvish",
								args = {
									"-c",
									"'use str; from-lines | each { |l| str:trim-right $l \" \" } | to-lines'",
								},
								stdin = true,
							}
						end,
					},
					bzl = {
						function()
							return {
								exe = "buildifier",
								args = { "-path", vim.api.nvim_buf_get_name(0) },
								stdin = true,
							}
						end,
					},
					css = { prettier },
					html = { prettier },
					go = {
						function()
							return { exe = "gofmt", stdin = true }
						end,
					},
					javascript = { prettier },
					json = { prettier },
					lua = { require("formatter.filetypes.lua").stylua },
					markdown = { prettier },
					python = {
						function()
							return {
								exe = "black",
								args = { "-" },
								stdin = true,
							}
						end,
					},
					scss = { prettier },
					sh = {
						function()
							return { exe = "shfmt", stdin = true }
						end,
					},
					sql = {
						function()
							return {
								exe = "pg_format",
								stdin = true,
							}
						end,
					},
					typescript = { prettier },
					yaml = { prettier },
				},
			})
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			local cfg = require("lspconfig")

			local servers = {
				"bashls",
				"cssls",
				"dockerls",
				"gopls",
				"jsonls",
				"pyright",
				"tsserver",
				"yamlls",
			}
			for _, s in pairs(servers) do
				require("lspconfig")[s].setup({})
			end

			cfg.sumneko_lua.setup({
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
			})
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
			{ "kyazdani42/nvim-web-devicons" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			local actions = require("telescope.actions")
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					layout_strategy = "vertical",
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
			})

			telescope.load_extension("fzf")
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
					"elvish",
					"html",
					"go",
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
					enable = true,
				},
			})
		end,
	})
end)

local cd = function()
	local action_state = require("telescope.actions.state")
	local actions = require("telescope.actions")
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local sorters = require("telescope.sorters")

	local ls = { "fd", "--base-directory", vim.fn.expand("$HOME") .. "/Projects", "-a", "-d", "2", "-t", "d" }

	pickers
		.new({}, {
			prompt_title = "Change Directory",
			finder = finders.new_oneshot_job(ls),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function(prompt, _)
				actions.select_default:replace(function()
					actions.close(prompt)
					vim.cmd("cd " .. action_state.get_selected_entry()[1])
				end)
				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("Cd", cd, {})
vim.api.nvim_create_user_command("Reload", "source $MYVIMRC | PackerCompile", {})

vim.keymap.set("i", "<f1>", vim.lsp.buf.signature_help)

vim.keymap.set("n", "==", ":Format<cr>")
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<cr>")
vim.keymap.set("n", "]g", ":Gitsigns next_hunk<cr>")
vim.keymap.set("n", "ga", ":Telescope lsp_code_actions<cr>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.rename)
vim.keymap.set("n", "gu", ":Telescope lsp_references<cr>")

vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")

local keybinds = vim.fn.stdpath("config") .. "/keybinds.lua"
vim.cmd("source " .. keybinds)
