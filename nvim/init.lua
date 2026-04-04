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
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.cs", "*.elv", "*.go", "*.lua", "*.py", "*.typ" },
	callback = function()
		vim.treesitter.start()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
	end,
})

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
vim.pack.add({
	"https://github.com/ravsii/tree-sitter-d2",
	"https://github.com/github/copilot.vim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

---@param id string
---@param cfg table?
local function setup(id, cfg)
	cfg = cfg or {}
	local pkg = require(id)
	pkg.setup(cfg)
end

vim.lsp.config["elvish"] = {
	cmd = { "elvish", "-lsp" },
	filetypes = { "elvish" },
}
vim.lsp.enable("angularls")
vim.lsp.enable("elvish")
vim.lsp.enable("gopls")
vim.lsp.enable("harper_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyrefly")
vim.lsp.enable("roslyn_ls")
vim.lsp.enable("terraformls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("tinymist")
vim.lsp.enable("tombi")

setup("mini.bracketed")
setup("mini.completion")
setup("mini.diff", { view = { style = "sign" } })
setup("mini.extra")
setup("mini.icons")
setup("mini.pairs")
setup("mini.files")
setup("mini.pick")
setup("mini.surround")

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

vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, {})

local d2_setup = function()
	local cfg = vim.fn.stdpath("config") .. "/queries/d2"
	vim.fn.system({ "rm", "-rf", cfg })
	vim.fn.system({ "mkdir", "-p", cfg })
	local queries = vim.fn.stdpath("data") .. "/site/pack/core/opt/tree-sitter-d2/queries/"
	vim.fn.system({ "cp", "-R", queries, cfg })
end

vim.api.nvim_create_user_command("D2Setup", d2_setup, {})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local ts_maps = {
	{
		{ "x", "o" },
		"aa",
		function()
			select.select_textobject("@parameter.outer", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"ia",
		function()
			select.select_textobject("@parameter.inner", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"ac",
		function()
			select.select_textobject("@conditional.outer", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"ic",
		function()
			select.select_textobject("@conditional.inner", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"af",
		function()
			select.select_textobject("@function.outer", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"if",
		function()
			select.select_textobject("@function.inner", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"al",
		function()
			select.select_textobject("@loop.outer", "textobjects")
		end,
	},
	{
		{ "x", "o" },
		"il",
		function()
			select.select_textobject("@loop.inner", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"]a",
		function()
			move.goto_next_start("@parameter.inner", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"]c",
		function()
			move.goto_next_start("@conditional.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"]f",
		function()
			move.goto_next_start("@function.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"]l",
		function()
			move.goto_next_start("@loop.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"]r",
		function()
			move.goto_next_start("@return.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"[a",
		function()
			move.goto_previous_start("@parameter.inner", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"[c",
		function()
			move.goto_previous_start("@conditional.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"[f",
		function()
			move.goto_previous_start("@function.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"[l",
		function()
			move.goto_previous_start("@loop.outer", "textobjects")
		end,
	},
	{
		{ "n", "x", "o" },
		"[r",
		function()
			move.goto_previous_start("@return.outer", "textobjects")
		end,
	},
	{
		"n",
		"]sa",
		function()
			swap.swap_next("@parameter.inner")
		end,
	},
	{
		"n",
		"]sf",
		function()
			swap.swap_next("@function.outer")
		end,
	},
	{
		"n",
		"[sa",
		function()
			swap.swap_previous("@parameter.inner")
		end,
	},
	{
		"n",
		"[sf",
		function()
			swap.swap_previous("@function.outer")
		end,
	},
}

for _, km in ipairs(ts_maps) do
	vim.keymap.set(km[1], km[2], km[3])
end

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
	{ "i", "<c-f>",    "<right>" },
	{ "i", "<c-b>",    "<left>" },
	{ "i", "<c-k>",    vim.lsp.buf.signature_help },
	{ "n", "[<space>", "O<esc>j" },
	{ "n", "]<space>", "o<esc>k" },
	{
		"n",
		"==",
		function()
			require("conform").format({ async = true, lsp_fallback = true })
		end,
	},
	{ "n", "K",  vim.lsp.buf.hover },
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
	{ "n", "<leader>r", vim.lsp.buf.rename },

	{ "n", "-",         "workbench.view.explorer",                     true },
	{ "n", "_",         "workbench.view.scm",                          true },
	{ "n", "<tab>",     "editor.action.inlineSuggest.commit",          true },
	{ "n", "==",        "editor.action.format",                        true },
	{ "n", "=i",        "editor.action.organizeImports",               true },
	{ "n", "[g",        "editor.action.marker.prev",                   true },
	{ "n", "]g",        "editor.action.marker.next",                   true },
	{ "n", "[q",        "search.action.focusPreviousSearchResult",     true },
	{ "n", "]q",        "search.action.focusNextSearchResult",         true },
	{ "n", "[h",        "editor.action.dirtydiff.previous",            true },
	{ "n", "]h",        "editor.action.dirtydiff.next",                true },
	{ "n", "<leader>-", "workbench.files.action.focusOpenEditorsView", true },
	{ "n", "<leader>b", "editor.debug.action.toggleBreakpoint",        true },
	{ "n", "<leader>d", "git.openChange",                              true },
	{ "v", "gh",        "git.diff.stageSelection",                     true },
	{ "v", "gH",        "git.revertSelectedRanges",                    true },
	{ "n", "z1",        "editor.foldLevel1",                           true },
	{ "n", "z2",        "editor.foldLevel2",                           true },
	{ "n", "z3",        "editor.foldLevel3",                           true },
	{ "n", "zM",        "editor.foldAll",                              true },
	{ "n", "zR",        "editor.unfoldAll",                            true },
	{ "n", "zc",        "editor.fold",                                 true },
	{ "n", "zC",        "editor.foldRecursively",                      true },
	{ "n", "zo",        "editor.unfold",                               true },
	{ "n", "zO",        "editor.unfoldRecursively",                    true },
	{ "n", "za",        "editor.toggleFold",                           true },
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
