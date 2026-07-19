.PHONY: *

config:
	ln -fs $(PWD)/elvish/rc.elv ~/.config/elvish/rc.elv
	ln -fs $(PWD)/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
	ln -fs $(PWD)/git/config ~/.config/git/config
	ln -fs $(PWD)/helix/config.toml ~/.config/helix/config.toml
	ln -fs $(PWD)/helix/languages.toml ~/.config/helix/languages.toml
	ln -fs $(PWD)/nushell/config.nu ~/Library/Application\ Support/nushell/config.nu
	ln -fs $(PWD)/psql/.pg_format ~/.pg_format
	ln -fs $(PWD)/psql/.psqlrc ~/.psqlrc
	ln -fs $(PWD)/ripgrep/ripgreprc ~/.config/ripgreprc
	ln -fs $(PWD)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -fs $(PWD)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -fs $(PWD)/zed/keymap.json ~/.config/zed/keymap.json
	ln -fs $(PWD)/zed/settings.json ~/.config/zed/settings.json

unconfig:
	rm ~/.config/elvish/rc.elv
	rm ~/Library/Application\ Support/com.mitchellh.ghostty/config
	rm ~/.config/git/config
	rm ~/.config/helix/config.toml
	rm ~/.config/helix/languages.toml
	rm ~/.pg_format
	rm ~/.psqlrc
	rm ~/.config/ripgreprc
	rm ~/Library/Application\ Support/Code/User/keybindings.json
	rm ~/Library/Application\ Support/Code/User/settings.json
	rm ~/Library/Application\ Support/nushell/config.nu
	rm ~/.config/zed/keymap.json
	rm ~/.config/zed/settings.json

fmt:
	prettier -w .

fmt-check:
	prettier -c .

install:
	softwareupdate --install --all
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew bundle install --file brew/brewfile
	brew doctor
