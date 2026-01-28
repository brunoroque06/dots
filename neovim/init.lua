_G.vim = vim

vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

-- Commands
vim.opt.timeout = false

-- Completion
vim.o.completeopt = "fuzzy,menuone,noselect"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:list,full"
vim.opt.wildoptions = "fuzzy"

-- Edition
vim.opt.swapfile = false

-- Fold
vim.opt.foldenable = false
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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
vim.opt.background = "light"
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
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
		"https://github.com/nvim-mini/mini.nvim",
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

local add = require("mini.deps").add

add({ source = "neovim/nvim-lspconfig" })
vim.lsp.config["elvish"] = {
	cmd = { "elvish", "-lsp" },
	filetypes = { "elvish" },
}
vim.lsp.enable("angularls")
vim.lsp.enable("elvish")
vim.lsp.enable("gopls")
vim.lsp.enable("harper_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("roslyn_ls")
vim.lsp.enable("terraformls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("tinymist")
vim.lsp.enable("tombi")

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
	auto_install = true,
	highlight = {
		enable = true,
	},
	textobjects = {
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]a"] = "@parameter.inner",
				["]c"] = "@conditional.outer",
				["]f"] = "@function.outer",
				["]l"] = "@loop.outer",
				["]r"] = "@return.outer",
			},
			goto_previous_start = {
				["[a"] = "@parameter.inner",
				["[c"] = "@conditional.outer",
				["[f"] = "@function.outer",
				["[l"] = "@loop.outer",
				["[r"] = "@return.outer",
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
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["]sa"] = "@parameter.inner",
				["]sf"] = "@function.outer",
			},
			swap_previous = {
				["[sa"] = "@parameter.inner",
				["[sf"] = "@function.outer",
			},
		},
	},
})
local d2_install = function(p)
	local dir = vim.fn.stdpath("config") .. "/queries/d2"
	vim.fn.system({ "rm", "-rf", dir })
	vim.fn.system({ "mkdir", "-p", dir })
	vim.fn.system({ "cp", "-R", p.path .. "/queries/", dir })
end
add({
	source = "ravsii/tree-sitter-d2",
	hooks = {
		post_checkout = d2_install,
		post_install = d2_install,
	},
})

add({ source = "nvim-mini/mini.nvim" })
setup("mini.bracketed")
setup("mini.completion")
setup("mini.diff", { view = { style = "sign" } })
setup("mini.extra")
setup("mini.hues", { background = "#ffffff", foreground = "#000080", accent = "fg", saturation = "high" })
setup("mini.icons")
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
		jb = {
			command = "jb",
			args = { "cleanupcode", "$FILENAME" },
			stdin = false,
		},
	},
	formatters_by_ft = {
		cs = { "jb" },
		d2 = { "d2" },
		elvish = { "elv" },
		go = { "gofmt" },
		javascript = { "prettier" },
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

add({ source = "github/copilot.vim" })

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

---@param mode string
---@param lhs string
---@param cmds string|string[]
local function code_map(mode, lhs, cmds)
	if type(cmds) == "string" then
		cmds = { cmds }
	end
	local func = function()
		for _, cmd in ipairs(cmds) do
			require("vscode").call(cmd)
		end
	end
	map(mode, lhs, func)
end

local binds = {
	{ "i", "<c-f>", "<right>" },
	{ "i", "<c-b>", "<left>" },
	{ "i", "<c-k>", vim.lsp.buf.signature_help },
	{ "n", "[<space>", "O<esc>j" },
	{ "n", "]<space>", "o<esc>k" },
	{
		"n",
		"==",
		function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
	},
	{ "n", "cd", vim.lsp.buf.rename },
	{ "n", "K", vim.lsp.buf.hover },
	{ "n", "g/", ":grep " },
	{ "n", "gD", vim.lsp.buf.type_definition },
	{ "n", "gd", vim.lsp.buf.definition },
	{ "n", "gi", vim.lsp.buf.implementation },
	{ "n", "gr", vim.lsp.buf.references },
	{
		"n",
		"gs",
		function()
			require("mini.extra").pickers.lsp({ scope = "document_symbol" })
		end,
	},
	{
		"n",
		"gS",
		function()
			require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
		end,
	},
	{
		"n",
		"-",
		function()
			require("mini.files").open(vim.fn.expand("%:p"))
		end,
	},
	{
		"n",
		"<leader>,",
		function()
			vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
		end,
	},
	{ "n", "<leader>a", vim.lsp.buf.code_action },
	{ "n", "<leader>b", require("mini.pick").builtin.buffers },
	{ "n", "<leader>d", require("mini.diff").toggle_overlay },
	{ "n", "<leader>f", require("mini.pick").builtin.files },
	{ "n", "<leader>g", require("mini.pick").builtin.grep_live },
	{ "n", "<leader>k", require("mini.extra").pickers.commands },

	{ "n", "-", "workbench.view.explorer", true },
	{ "n", "<tab>", "editor.action.inlineSuggest.commit", true },
	{ "n", "==", "editor.action.format", true },
	{ "n", "=i", "editor.action.organizeImports", true },
	{ "n", "[d", "editor.action.marker.prev", true },
	{ "n", "]d", "editor.action.marker.next", true },
	{ "n", "[q", "search.action.focusPreviousSearchResult", true },
	{ "n", "]q", "search.action.focusNextSearchResult", true },
	{ "n", "[h", "editor.action.dirtydiff.previous", true },
	{ "n", "]h", "editor.action.dirtydiff.next", true },
	{ "n", "<leader>-", "workbench.files.action.focusOpenEditorsView", true },
	{ "n", "<leader>b", "editor.debug.action.toggleBreakpoint", true },
	{ "n", "<leader>d", "git.openChange", true },
	{ "v", "gh", "git.diff.stageSelection", true },
	{ "v", "gH", "git.revertSelectedRanges", true },
	{ "n", "z1", "editor.foldLevel1", true },
	{ "n", "z2", "editor.foldLevel2", true },
	{ "n", "z3", "editor.foldLevel3", true },
	{ "n", "zM", "editor.foldAll", true },
	{ "n", "zR", "editor.unfoldAll", true },
	{ "n", "zc", "editor.fold", true },
	{ "n", "zC", "editor.foldRecursively", true },
	{ "n", "zo", "editor.unfold", true },
	{ "n", "zO", "editor.unfoldRecursively", true },
	{ "n", "za", "editor.toggleFold", true },
}

for _, b in ipairs(binds) do
	local mode, lhs, rhs, code = unpack(b)
	if code then
		if vim.g.vscode then
			code_map(mode, lhs, rhs)
		end
	else
		map(mode, lhs, rhs)
	end
end
