use readline-binding
use str

E:EDITOR = 'another'
E:VISUAL = 'nvim'

E:FZF_DEFAULT_OPTS = '--border=sharp --height 20% --reverse'
E:FZF_CTRL_T_COMMAND = 'fd . --type f --hidden -E .git'
E:FZF_CTRL_T_OPTS = "--height 40% --preview 'bat {}' --preview-window border-left"

E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"

E:RIPGREP_CONFIG_PATH = ~/.config/ripgreprc

set paths = [
  ~/.local/share/gem/ruby/3.0.0/bin
  /usr/local/opt/ruby/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/share/dotnet
  ~/.dotnet/tools
  /usr/local/opt/qt/bin
]

fn z { edit:location:start }

edit:insert:binding["Ctrl-["] = { edit:command:start }
fn a { edit:histlist:start }
fn d { edit:navigation:start }
fn di { edit:location:start }

edit:command:binding[a] = { edit:move-dot-right; edit:close-mode }
edit:command:binding[A] = { edit:move-dot-eol; edit:close-mode }
edit:command:binding[C] = { edit:kill-line-right; edit:close-mode }
edit:command:binding[I] = { edit:move-dot-sol; edit:close-mode }
edit:command:binding[s] = { edit:move-dot-right; edit:kill-rune-left; edit:close-mode }
edit:command:binding[x] = { edit:move-dot-right; edit:kill-rune-left }

# Azure
fn az-subi { az account list | jq -r '.[] | [.id, .name] | join("\t")' | fzf | awk '{print $1F}' | xargs -t az account set --subscription }

# Brew
edit:small-word-abbr['b'] = 'brew'
edit:small-word-abbr['bi'] = 'brew install'
fn brew-dump { brew bundle dump --file ~/Projects/dotfiles/brew/Brewfile --force }
fn brew-l { brew leaves }
fn brew-lc { brew list --cask -1 }
fn brew-up { brew update; brew upgrade --ignore-pinned; brew cleanup; brew doctor }

# Docker
edit:small-word-abbr['doc'] = 'docker'
edit:small-word-abbr['docc'] = 'docker-compose'
fn doc-ps { docker ps -a }
fn doc-rm { docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f }
fn doc-rmi { docker rmi -f (docker images -a -q) }
fn doc-stop { docker stop (docker ps -a -q) }

# Dotnet
edit:small-word-abbr['d'] = 'dotnet'
edit:small-word-abbr['dr'] = 'dotnet run'
edit:small-word-abbr['dt'] = 'dotnet test'
fn dot-fmt { dotnet format }
fn dot-fsi { dotnet fsi }
fn dot-tup { dotnet tool list -g | awk 'NR > 2 {print $1}' | xargs -t -I % dotnet tool update -g % }
fn dot-up { dotnet outdated --upgrade }

# Edit
fn e [@a]{ nvim $@a }
fn ed [@a]{ nvim -d $@a }
fn en [@a]{ nvim -u NONE $@a }
fn er [@a]{ nvim -MR $@a }

# File System
fn c [@a]{ bat $@a }
fn l [@a]{ exa -al }
fn dir-rmi { du -hd 1 | fzf -m | each [d]{ str:split './' $d | drop 1 | rm -rf (one) } }
fn dir-size { du -h -d 1 | sort -hr }
fn file-rmi { fd . --hidden --max-depth 1 --no-ignore | fzf -m | xargs -t -I % rm -rf "%" }
fn file-yi { rg --files | fzf | xargs -t cat | pbcopy }

# Git
edit:small-word-abbr['g'] = 'git'
edit:small-word-abbr['gco'] = 'git checkout'
edit:small-word-abbr['gunstage'] = 'git reset HEAD --'
fn gi { tig }
fn gfa { git fetch --all }
fn gl { git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d' -20 }
fn gph { git push }
fn gphf { git push --force }
fn gs { git status }
fn git-cfg { git config --list --show-origin }

# Keyboard
fn karabiner-dump { cp ~/.config/karabiner/karabiner.json ~/Projects/dotfiles/karabiner }
fn karabiner-load { cp ~/Projects/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json }

# Makefile
edit:small-word-abbr['m'] = 'make'

# Network
fn scan { nmap -sP 192.168.1.0/24 }

# Node.js
edit:small-word-abbr['n'] = 'npm'
fn nci { npm ci }
fn ni { npm install }
fn nlg { npm list -g --depth=0 }
fn nr { npm run }
fn ns { cat package.json | jq '.scripts' }
fn nupg { npm update -g }
fn nupi { npx npm-check-updates --deep -i }
edit:small-word-abbr['y'] = 'yarn'
fn yupi { yarn upgrade-interactive }

# PostgreSQL
fn pg-up { postgres -D /usr/local/var/postgres }
fn pg-reset { brew uninstall --ignore-dependencies postgresql; rm -rf /usr/local/var/postgres; brew install postgresql; /usr/local/bin/timescaledb_move.sh }
fn pg-upgrade { brew postgresql-upgrade-database }

# Python
edit:small-word-abbr['po'] = 'poetry'
fn po-setup { poetry init; poetry add --dev black mypy pylint }
edit:small-word-abbr['py'] = 'python'

# Pulumi
edit:small-word-abbr['pu'] = 'pulumi'
fn pud { pulumi destroy }
fn puds { pulumi destroy --skip-preview }
fn pup { pulumi preview }
fn pusdi { pulumi stack export | jq -r '.deployment.resources[].urn' | fzf | xargs -t pulumi state delete }
fn pussi { pulumi stack ls --json | jq -r '.[].name' | fzf | xargs -t pulumi stack select }
fn puso { pulumi stack output --show-secrets }
fn puu { pulumi up }
fn puus { pulumi up --skip-preview }

# VSCode
fn c. { code . }
fn code-ex-dump { code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt" }
fn code-ex-install { xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension }

# Web Browser
fn webbrowser { rm -rf /tmp/chrome_dev_test; /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:4200" }

