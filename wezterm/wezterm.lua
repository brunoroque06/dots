local w = require("wezterm")

local home = os.getenv("HOME")

return {
	default_prog = { "/opt/homebrew/bin/fish", "-l" },

	color_scheme = "Gruvbox Dark",

	font = w.font({
		family = "JetBrains Mono",
	}),
	font_size = 13.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	window_frame = {
		font = w.font({ family = "JetBrains Mono" }),
		font_size = 13.0,
	},

	launch_menu = {
		{
			args = { "top" },
		},
		{
			label = "dotfiles",
			cwd = home .. "/Projects/dotfiles",
		},
	},

	keys = {
		{ key = "d", mods = "CMD", action = w.action({ ScrollByPage = 0.5 }) },
		{ key = "l", mods = "CMD", action = "ShowLauncher" },
		{ key = "m", mods = "CMD", action = "DisableDefaultAssignment" },
		{ key = "r", mods = "CMD", action = "ReloadConfiguration" },
		{ key = "u", mods = "CMD", action = w.action({ ScrollByPage = -0.5 }) },
		{ key = "w", mods = "CMD", action = w.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "x", mods = "CMD", action = "ActivateCopyMode" },
		{ key = "y", mods = "CMD", action = "QuickSelect" },
		{ key = "z", mods = "CMD", action = "TogglePaneZoomState" },
		{ key = "Enter", mods = "CMD", action = w.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "Enter", mods = "CMD|SHIFT", action = w.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = "[", mods = "CMD", action = w.action({ ActivatePaneDirection = "Prev" }) },
		{ key = "]", mods = "CMD", action = w.action({ ActivatePaneDirection = "Next" }) },
	},
}
