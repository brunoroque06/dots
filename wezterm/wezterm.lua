local wez = require("wezterm")

local home = os.getenv("HOME")

wez.on("update-right-status", function(window, _)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

return {
	default_prog = { "/opt/homebrew/bin/fish", "-l" },

	color_scheme = "Gruvbox Dark",

	font = wez.font({
		family = "JetBrains Mono",
	}),
	font_size = 13.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	window_frame = {
		font = wez.font({ family = "JetBrains Mono" }),
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
		{ key = "d", mods = "CMD", action = wez.action({ ScrollByPage = 0.5 }) },
		{ key = "l", mods = "CMD", action = "ShowLauncher" },
		{ key = "m", mods = "CMD", action = "DisableDefaultAssignment" },
		{
			key = "r",
			mods = "CMD",
			action = wez.action({
				ActivateKeyTable = {
					name = "resize_pane",
					one_shot = false,
				},
			}),
		},
		{ key = "u", mods = "CMD", action = wez.action({ ScrollByPage = -0.5 }) },
		{ key = "w", mods = "CMD", action = wez.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "x", mods = "CMD", action = "ActivateCopyMode" },
		{ key = "y", mods = "CMD", action = "QuickSelect" },
		{ key = "z", mods = "CMD", action = "TogglePaneZoomState" },
		{ key = "Enter", mods = "CMD", action = wez.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{
			key = "Enter",
			mods = "CMD|SHIFT",
			action = wez.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "[", mods = "CMD", action = wez.action({ ActivatePaneDirection = "Prev" }) },
		{ key = "]", mods = "CMD", action = wez.action({ ActivatePaneDirection = "Next" }) },
	},

	key_tables = {
		resize_pane = {
			{ key = "LeftArrow", action = wez.action({ AdjustPaneSize = { "Left", 10 } }) },
			{ key = "h", action = wez.action({ AdjustPaneSize = { "Left", 10 } }) },
			{ key = "RightArrow", action = wez.action({ AdjustPaneSize = { "Right", 10 } }) },
			{ key = "l", action = wez.action({ AdjustPaneSize = { "Right", 10 } }) },
			{ key = "UpArrow", action = wez.action({ AdjustPaneSize = { "Up", 10 } }) },
			{ key = "k", action = wez.action({ AdjustPaneSize = { "Up", 10 } }) },
			{ key = "DownArrow", action = wez.action({ AdjustPaneSize = { "Down", 10 } }) },
			{ key = "j", action = wez.action({ AdjustPaneSize = { "Down", 10 } }) },
			{ key = "Escape", action = "PopKeyTable" },
		},
	},
}