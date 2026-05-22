.PHONY: *

config:
	ln -s $(PWD)/elvish/rc.elv ~/.config/elvish/rc.elv
	ln -s $(PWD)/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
	ln -s $(PWD)/git/config ~/.config/git/config
	ln -s $(PWD)/git/ignore ~/.config/git/ignore
	ln -s $(PWD)/helix/config.toml ~/.config/helix/config.toml
	ln -s $(PWD)/helix/languages.toml ~/.config/helix/languages.toml
	ln -s $(PWD)/ideavim/.ideavimrc ~/.ideavimrc
	ln -s $(PWD)/nvim/init.lua ~/.config/nvim/init.lua
	ln -s $(PWD)/psql/.pg_format ~/.pg_format
	ln -s $(PWD)/psql/.psqlrc ~/.psqlrc
	ln -s $(PWD)/ripgrep/ripgreprc ~/.config/ripgreprc
	ln -s $(PWD)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -s $(PWD)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -s $(PWD)/zed/keymap.json ~/.config/zed/keymap.json
	ln -s $(PWD)/zed/settings.json ~/.config/zed/settings.json

unconfig:
	rm ~/.config/elvish/rc.elv
	rm ~/Library/Application\ Support/com.mitchellh.ghostty/config
	rm ~/.config/git/config
	rm ~/.config/git/ignore
	rm ~/.config/helix/config.toml
	rm ~/.config/helix/languages.toml
	rm ~/.ideavimrc
	rm ~/.config/nvim/init.lua
	rm ~/.pg_format
	rm ~/.psqlrc
	rm ~/.config/ripgreprc
	rm ~/Library/Application\ Support/Code/User/keybindings.json
	rm ~/Library/Application\ Support/Code/User/settings.json
	rm ~/.config/zed/keymap.json
	rm ~/.config/zed/settings.json

fmt:
	prettier -w .
	stylua --verbose .

fmt-check:
	prettier -c .
	stylua --check --verbose .

install:
	softwareupdate --install --all
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew bundle install --file brew/brewfile
	brew doctor

lint:
	elvish -compileonly scripts/digest.elv
	lua-language-server --check nvim/init.lua
