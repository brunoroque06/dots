.PHONY: check config fmt fmt-check install macos unconfig

config:
	mkdir -p ~/.config/aerospace
	ln -fs $(CURDIR)/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
	mkdir -p ~/.config/elvish
	ln -fs $(CURDIR)/elvish/rc.elv ~/.config/elvish/rc.elv
	ln -fs $(CURDIR)/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
	mkdir -p ~/.config/git
	ln -fs $(CURDIR)/git/config ~/.config/git/config
	mkdir -p ~/.config/helix
	ln -fs $(CURDIR)/helix/config.toml ~/.config/helix/config.toml
	ln -fs $(CURDIR)/helix/languages.toml ~/.config/helix/languages.toml
	mkdir -p ~/.config/nushell
	ln -fs $(CURDIR)/nushell/config.nu ~/Library/Application\ Support/nushell/config.nu
	ln -fs $(CURDIR)/psql/.pg_format ~/.pg_format
	ln -fs $(CURDIR)/psql/.psqlrc ~/.psqlrc
	mkdir -p ~/.config/rift
	ln -fs $(CURDIR)/rift/config.toml ~/.config/rift/config.toml
	ln -fs $(CURDIR)/ripgrep/ripgreprc ~/.config/ripgreprc
	mkdir -p ~/Library/Application\ Support/Code/User/snippets
	ln -fs $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -fs $(CURDIR)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -fs $(CURDIR)/zed/snippets/csharp.json ~/Library/Application\ Support/Code/User/snippets/csharp.json
	ln -fs $(CURDIR)/zed/snippets/sql.json ~/Library/Application\ Support/Code/User/snippets/sql.json
	mkdir -p ~/.config/zed/snippets
	ln -fs $(CURDIR)/zed/keymap.json ~/.config/zed/keymap.json
	ln -fs $(CURDIR)/zed/settings.json ~/.config/zed/settings.json
	ln -fs $(CURDIR)/zed/tasks.json ~/.config/zed/tasks.json
	ln -fs $(CURDIR)/zed/snippets/csharp.json ~/.config/zed/snippets/csharp.json
	ln -fs $(CURDIR)/zed/snippets/sql.json ~/.config/zed/snippets/sql.json

unconfig:
	rm ~/.config/aerospace/aerospace.toml
	rm ~/.config/elvish/rc.elv
	rm ~/Library/Application\ Support/com.mitchellh.ghostty/config
	rm ~/.config/git/config
	rm ~/.config/helix/config.toml
	rm ~/.config/helix/languages.toml
	rm ~/.pg_format
	rm ~/.psqlrc
	rm ~/.config/rift/config.toml
	rm ~/.config/ripgreprc
	rm ~/Library/Application\ Support/Code/User/keybindings.json
	rm ~/Library/Application\ Support/Code/User/settings.json
	rm ~/Library/Application\ Support/Code/User/snippets/csharp.json
	rm ~/Library/Application\ Support/Code/User/snippets/sql.json
	rm ~/Library/Application\ Support/nushell/config.nu
	rm ~/.config/zed/keymap.json
	rm ~/.config/zed/settings.json
	rm ~/.config/zed/snippets/csharp.json
	rm ~/.config/zed/snippets/sql.json

fmt:
	prettier -w .
	nufmt nushell/config.nu

fmt-check:
	prettier -c .
	nufmt --dry-run nushell/config.nu

check:
	nu -n -c 'nu-check -d nushell/config.nu'

install:
	softwareupdate --install --all
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew bundle install --file brew/brewfile
	brew doctor

macos:
	# Dock
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock autohide-delay -float 0
	defaults write com.apple.dock mru-spaces -bool false
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock wvous-br-corner -int 13

	# Finder
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	defaults write com.apple.finder AppleShowAllFiles -bool true
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
	defaults write com.apple.finder ShowPathbar -bool true

	# Keyboard
	defaults write -g AppleKeyboardUIMode -int 2
	defaults write -g ApplePressAndHoldEnabled -bool false
	defaults write -g InitialKeyRepeat -int 10
	defaults write -g KeyRepeat -int 1
	defaults write -g NSAutomaticCapitalizationEnabled -bool false
	defaults write -g NSAutomaticInlinePredictionEnabled -bool false
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

	# Safari
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari ShowStandaloneTabBar -bool false

	# Trackpad
	defaults write -g com.apple.trackpad.scrolling -float 1

	killall Dock Finder SystemUIServer
