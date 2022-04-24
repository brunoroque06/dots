local wez = require("wezterm")

local home = os.getenv("HOME")

wez.on("update-right-status", function(window, _)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name .. " "
	end
	window:set_right_status(name or "")
end)

local gruv = wez.get_builtin_color_schemes()["Gruvbox Dark"]

local rose = {
	foreground = "#575279",
	background = "#faf4ed",
	cursor_bg = "#9893a5",
	cursor_border = "#9893a5",
	cursor_fg = "#575279",
	selection_bg = "#f2e9e1",
	selection_fg = "#575279",
	ansi = { "#f2e9de", "#b4637a", "#286983", "#ea9d34", "#56949f", "#907aa9", "#d7827e", "#575279" },
	brights = { "#6e6a86", "#b4637a", "#286983", "#ea9d34", "#56949f", "#907aa9", "#d7827e", "#575279" },
}

local zenbones = {
	foreground = "#2c363c",
	background = "#f0edec",
	cursor_bg = "#2c363c",
	cursor_border = "#f0edec",
	cursor_fg = "#f0edec",
	selection_bg = "#cbd9e3",
	selection_fg = "#2c363c",
	ansi = { "#f0edec", "#a8334c", "#4f6c31", "#944927", "#286486", "#88507d", "#3b8992", "#2c363c" },
	brights = { "#cfc1ba", "#94253e", "#3f5a22", "#803d1c", "#1d5573", "#7b3b70", "#2b747c", "#4f5e68" },
}

local scheme = zenbones

local colors = {
	foreground = scheme.foreground,
	background = scheme.background,
	cursor_bg = scheme.cursor_bg,
	cursor_border = scheme.cursor_border,
	cursor_fg = scheme.cursor_fg,
	selection_bg = scheme.selection_bg,
	selection_fg = scheme.selection_fg,
	ansi = scheme.ansi,
	brights = scheme.brights,

	scrollbar_thumb = scheme.selection_bg,
	split = scheme.background,

	tab_bar = {
		background = scheme.background,
		active_tab = {
			bg_color = scheme.selection_bg,
			fg_color = scheme.selection_fg,
		},
		inactive_tab = {
			bg_color = scheme.background,
			fg_color = scheme.foreground,
		},
		inactive_tab_hover = {
			bg_color = scheme.selection_bg,
			fg_color = scheme.selection_fg,
		},
		new_tab = {
			bg_color = scheme.background,
			fg_color = scheme.foreground,
		},
		new_tab_hover = {
			bg_color = scheme.selection_bg,
			fg_color = scheme.selection_fg,
		},
	},
}

return {
	-- Why is my directory $TMPDIR removed periodically, regardless of the age of the file/directory?
	-- Debug: sudo fs_usage -w | rg rmdir | rg var/folders/*/*/T/elvish
	-- { "/opt/homebrew/bin/elvish", "-sock", home .. "/.local/state/elvish/sock" },
	default_prog = { "/opt/homebrew/bin/elvish" },

	colors = colors,

	font = wez.font("JetBrains Mono", { weight = "Regular" }),
	font_size = 13.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	enable_scroll_bar = true,

	use_fancy_tab_bar = false,

	launch_menu = {
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
			key = "o",
			mods = "CMD",
			action = wez.action({
				QuickSelectArgs = {
					label = "open url",
					patterns = {
						"https?://\\S+",
					},
					action = wez.action_callback(function(window, pane)
						local url = window:get_selection_text_for_pane(pane)
						wez.log_info("opening: " .. url)
						wez.open_with(url)
					end),
				},
			}),
		},
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
