vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

-- Commands
vim.opt.timeout = false
vim.opt.ttimeout = false

-- Completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:list,full"
vim.opt.wildoptions = "fuzzy"

-- Fold
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"

-- Indentation
vim.opt.autoindent = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Search
vim.opt.ignorecase = true
vim.opt.grepprg = "rg --hidden --smart-case --vimgrep"
vim.opt.smartcase = true

-- UI
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

local pcks = vim.fn.stdpath("data") .. "/site/"
local mini = pcks .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini) then
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini,
	}
	vim.fn.system(clone_cmd)
end

local function setup(name, cfg, sub)
	cfg = cfg or {}

	local pkg = require(name)

	if sub then
		pkg[sub].setup(cfg)
	else
		pkg.setup(cfg)
	end
end

setup("mini.deps", { path = { package = pcks } })

local add = MiniDeps.add

add({
	source = "nvim-treesitter/nvim-treesitter-textobjects",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
	depends = { "nvim-treesitter/nvim-treesitter" },
})
setup("nvim-treesitter.configs", {
	textobjects = {
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]a"] = "@parameter.inner",
				["]c"] = "@conditional.outer",
				["]f"] = "@function.outer",
				["]l"] = "@loop.outer",
				["]s"] = "@statement.outer",
			},
			goto_previous_start = {
				["[a"] = "@parameter.inner",
				["[c"] = "@conditional.outer",
				["[f"] = "@function.outer",
				["[l"] = "@loop.outer",
				["[s"] = "@statement.outer",
			},
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["as"] = "@statement.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>sa"] = "@parameter.inner",
				["<leader>sf"] = "@function.outer",
			},
			swap_previous = {
				["<leader>sA"] = "@parameter.inner",
				["<leader>sF"] = "@function.outer",
			},
		},
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
})

add({ source = "neovim/nvim-lspconfig" })
setup("lspconfig", nil, "angularls")
setup("lspconfig", nil, "gopls")
setup("lspconfig", nil, "pyright")
setup("lspconfig", nil, "ruff")
setup("lspconfig", nil, "terraformls")
setup("lspconfig", nil, "tinymist")
setup("lspconfig", nil, "ts_ls")
setup("lspconfig", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					mini .. "/lua",
					"${3rd}/luv/library",
				},
			},
		})
	end,
	settings = {
		Lua = {},
	},
}, "lua_ls")

add({
	source = "WhoIsSethDaniel/mason-tool-installer.nvim",
	depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
})
setup("mason")
setup("mason-lspconfig")
setup("mason-tool-installer", {
	ensure_installed = {
		"angular-language-server",
		"gopls",
		"lua-language-server",
		"stylua",
		"terraform-ls",
		"tinymist",
		"typescript-language-server",
	},
	auto_update = true,
	run_on_start = true,
})

add({ source = "seblyng/roslyn.nvim" })
setup("roslyn")

add({ source = "projekt0n/github-nvim-theme" })
vim.cmd("colorscheme github_light")

add({ source = "echasnovski/mini.nvim" })
setup("mini.bracketed")
setup("mini.completion")
setup("mini.extra")
setup("mini.pairs")
setup("mini.files")
setup("mini.pick")
setup("mini.surround")

add({ source = "stevearc/conform.nvim" })
setup("conform", {
	formatters_by_ft = {
		go = { "gofmt" },
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		terraform = { "terraform_fmt" },
		typst = { "typstyle" },
	},
})

local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "[<space>", "O<esc>j")
map("n", "]<space>", "o<esc>k")

map("n", "==", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format entire file" })

map("n", "cd", vim.lsp.buf.rename)

map("n", "g/", ":grep ")
map("n", "gD", vim.lsp.buf.type_definition)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gh", vim.lsp.buf.hover)
map("n", "gi", vim.lsp.buf.implementation)
map("n", "gr", vim.lsp.buf.references)
map("n", "gs", function()
	MiniExtra.pickers.lsp({ scope = "document_symbol" })
end)
map("n", "gs", function()
	MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
end)

map("n", "<leader>a", vim.lsp.buf.code_action)
map("n", "<leader>b", MiniPick.builtin.buffers)
map("n", "<leader>f", MiniPick.builtin.files)
map("n", "<leader>g", MiniPick.builtin.grep_live)
map("n", "<leader>l", require("mini.files").open)
