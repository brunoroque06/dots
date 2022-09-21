local wez = require("wezterm")

local home = os.getenv("HOME")

wez.on("update-right-status", function(window, _)
	local name = window:active_key_table()
	if name then
		name = "table: " .. name .. " "
	end
	window:set_right_status(name or "")
end)

local zenbones = {
	foreground = "#2c363c",
	background = "#f0edec",
	cursor_bg = "#2c363c",
	cursor_border = "#f0edec",
	cursor_fg = "#f0edec",
	selection_bg = "#cbd9e3",
	selection_fg = "#2c363c",
	ansi = { "#2c363c", "#a8334c", "#4f6c31", "#944927", "#286486", "#88507d", "#3b8992", "#f0edec" },
	brights = { "#4f5e68", "#94253e", "#3f5a22", "#803d1c", "#1d5573", "#7b3b70", "#2b747c", "#cfc1ba" },
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

	copy_mode_active_highlight_bg = { Color = scheme.selection_bg },
	copy_mode_active_highlight_fg = { Color = scheme.selection_fg },
	copy_mode_inactive_highlight_bg = { Color = scheme.ansi[4] },
	copy_mode_inactive_highlight_fg = { Color = scheme.ansi[8] },

	quick_select_label_bg = { Color = scheme.ansi[4] },
	quick_select_label_fg = { Color = scheme.ansi[8] },
	quick_select_match_bg = { Color = scheme.ansi[5] },
	quick_select_match_fg = { Color = scheme.ansi[8] },

	tab_bar = {
		background = scheme.background,
		active_tab = {
			bg_color = scheme.selection_bg,
			fg_color = scheme.selection_fg,
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = scheme.background,
			fg_color = scheme.foreground,
			intensity = "Bold",
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
	default_prog = { "/opt/homebrew/bin/elvish", "-sock", home .. "/.local/state/elvish/sock" },

	colors = colors,

	font = wez.font("JetBrains Mono", { weight = "Medium" }),
	font_size = 13,
	line_height = 1.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	enable_scroll_bar = true,

	use_fancy_tab_bar = false,
	tab_max_width = 16,

	window_close_confirmation = "NeverPrompt",

	window_padding = {
		left = "1cell",
		right = "1.5cell",
		top = "0.5cell",
		bottom = "0.5cell",
	},

	quick_select_patterns = {
		"[\\w\\.-]+azure[\\w\\.-]+",
		"npm -g install .+",
		"urn:pulumi:[\\w:/-_]+",
	},

	launch_menu = {
		{
			label = "dotfiles",
			cwd = home .. "/Projects/dotfiles",
		},
	},

	keys = {
		{ key = ",", mods = "CMD", action = wez.action.MoveTabRelative(-1) },
		{ key = ".", mods = "CMD", action = wez.action.MoveTabRelative(1) },
		{ key = "d", mods = "CMD", action = wez.action({ ScrollByPage = 0.5 }) },
		{ key = "f", mods = "CMD", action = wez.action.Search({ CaseInSensitiveString = "" }) },
		{ key = "m", mods = "CMD", action = wez.action.DisableDefaultAssignment },
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
		{ key = "p", mods = "CMD", action = wez.action.ShowLauncher },
		{
			key = "r",
			mods = "CMD",
			action = wez.action({
				ActivateKeyTable = {
					name = "resize_pane",
					one_shot = false,
					replace_current = false,
				},
			}),
		},
		{ key = "u", mods = "CMD", action = wez.action({ ScrollByPage = -0.5 }) },
		{ key = "w", mods = "CMD", action = wez.action({ CloseCurrentPane = { confirm = false } }) },
		{ key = "x", mods = "CMD", action = wez.action.ActivateCopyMode },
		{ key = "y", mods = "CMD", action = wez.action.QuickSelect },
		{ key = "z", mods = "CMD", action = wez.action.TogglePaneZoomState },
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
			{ key = "UpArrow", action = wez.action({ AdjustPaneSize = { "Up", 5 } }) },
			{ key = "k", action = wez.action({ AdjustPaneSize = { "Up", 5 } }) },
			{ key = "DownArrow", action = wez.action({ AdjustPaneSize = { "Down", 5 } }) },
			{ key = "j", action = wez.action({ AdjustPaneSize = { "Down", 5 } }) },
			{ key = "Escape", action = wez.action.PopKeyTable },
		},
	},
}
