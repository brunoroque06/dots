vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

-- Commands
vim.opt.timeout = false

-- Completion
vim.cmd("set completeopt+=noselect")
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:list,full"
vim.opt.wildoptions = "fuzzy"

-- Edition
vim.opt.swapfile = false

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
vim.o.winborder = "single"
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.signcolumn = "yes"

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- LSP
--- @param id string
--- @param cfg table
local function lsp(id, cfg)
	vim.lsp.config[id] = cfg
	vim.lsp.enable(id)
end

lsp("elv", { cmd = { "elvish", "-lsp" }, filetypes = { "elvish" } })
lsp("go", { cmd = { "gopls" }, filetypes = { "go" } })
lsp("grammar", { cmd = { "harper-ls", "--stdio" }, filetypes = { "markdown" } })
lsp("lua", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
lsp("ng", {
	cmd = { "ngserver", "--stdio", "--ngProbeLocations", ".", "--tsProbeLocations", "." },
	filetypes = { "typescript" },
	root_markers = { "angular.json" },
})
lsp("py", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
})
lsp("tf", {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform" },
})
lsp("ts", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript" },
	root_markers = { "package.json" },
})
lsp("typ", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local c = vim.lsp.get_client_by_id(ev.data.client_id)
		if c and c:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, c.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.diagnostic.config({ virtual_lines = false, virtual_text = true })

-- Plugins
local plugs = vim.fn.stdpath("data") .. "/site/"
local mini = plugs .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini) then
	local clone = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini,
	}
	vim.fn.system(clone)
end

---@param id string
---@param cfg table?
local function setup(id, cfg)
	cfg = cfg or {}
	local pkg = require(id)
	pkg.setup(cfg)
end

setup("mini.deps", { path = { package = plugs } })

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

add({ source = "seblyng/roslyn.nvim" })
setup("roslyn")

add({ source = "echasnovski/mini.nvim" })
setup("mini.bracketed")
setup("mini.diff", { view = { style = "sign" } })
setup("mini.extra")
setup("mini.pairs")
setup("mini.files")
setup("mini.pick")
setup("mini.surround")

add({ source = "stevearc/conform.nvim" })
setup("conform", {
	formatters = {
		elv = {
			command = "sed",
			args = { "-E", "-e", "s/[ 	]+$//", "-e", "s/ {2}/\t/g" },
			stdin = true,
		},
	},
	formatters_by_ft = {
		cs = { "csharpier" },
		elvish = { "elv" },
		go = { "gofmt" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		terraform = { "terraform_fmt" },
		typescript = { "prettier" },
		typst = { "typstyle" },
		yaml = { "prettier" },
	},
})

add({ source = "projekt0n/github-nvim-theme" })
vim.cmd("colorscheme github_light")

---@param mode string
---@param lhs string
---@param rhs function|string
---@param opts table?
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = true
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

map("i", "<c-f>", "<right>")
map("i", "<c-b>", "<left>")
map("i", "<c-k>", vim.lsp.buf.signature_help)

map("n", "[<space>", "O<esc>j")
map("n", "]<space>", "o<esc>k")

map("n", "==", function()
	require("conform").format({ async = true, lsp_fallback = true })
end)

map("n", "cd", vim.lsp.buf.rename)

map("n", "K", vim.lsp.buf.hover)

map("n", "g/", ":grep ")
map("n", "gD", vim.lsp.buf.type_definition)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gi", vim.lsp.buf.implementation)
map("n", "gr", vim.lsp.buf.references)
map("n", "gs", function()
	MiniExtra.pickers.lsp({ scope = "document_symbol" })
end)
map("n", "gS", function()
	MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
end)

map("n", "<leader>,", function()
	vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end)
map("n", "<leader>a", vim.lsp.buf.code_action)
map("n", "<leader>b", MiniPick.builtin.buffers)
map("n", "<leader>d", MiniDiff.toggle_overlay)
map("n", "<leader>f", MiniPick.builtin.files)
map("n", "<leader>g", MiniPick.builtin.grep_live)
map("n", "<leader>k", MiniExtra.pickers.commands)
map("n", "<leader>l", require("mini.files").open)
