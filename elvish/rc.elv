use readline-binding
use str

E:EDITOR = 'nvim'
E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
E:PAGER = 'less'
E:VISUAL = 'nvim'

E:RIPGREP_CONFIG_PATH = ~/.config/ripgreprc

set paths = [
  ~/.local/share/gem/ruby/3.0.0/bin
  /usr/local/opt/ruby/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/share/dotnet
  ~/.dotnet/tools
  /usr/local/opt/qt/bin
]

edit:prompt = { styled (tilde-abbr $pwd) blue; put (styled ' Λ ' magenta) }
edit:rprompt = (constantly (whoami)@(hostname))

edit:insert:binding["Ctrl-["] = { edit:command:start }
edit:insert:binding['Ctrl-f'] = { edit:navigation:start }
edit:insert:binding['Ctrl-l'] = { edit:location:start }
edit:insert:binding['Ctrl-o'] = { edit:lastcmd:start }
edit:insert:binding['Ctrl-r'] = { edit:histlist:start }

edit:command:binding['a'] = { edit:move-dot-right; edit:close-mode }
edit:command:binding['A'] = { edit:move-dot-eol; edit:close-mode }
edit:command:binding['C'] = { edit:kill-line-right; edit:close-mode }
edit:command:binding['I'] = { edit:move-dot-sol; edit:close-mode }
edit:command:binding['s'] = { edit:move-dot-right; edit:kill-rune-left; edit:close-mode }
edit:command:binding['x'] = { edit:move-dot-right; edit:kill-rune-left }

# Azure
fn az-subi { az account list | from-json | drop 0 (one) | each [s]{ put [&to-filter=$s[name] &to-accept=$s[id] &to-show=(if (eq $s[isDefault] $true) { put (styled $s[name] green) } else { put $s[name] })] } | edit:listing:start-custom [(all)] &caption='Azure Subscription' &accept=[s]{ az account set --subscription $s } }

# Brew
edit:small-word-abbr['bi'] = 'brew install'
edit:small-word-abbr['bl'] = 'brew leaves'
edit:small-word-abbr['blc'] = 'brew leaves --cask -1'
edit:small-word-abbr['bup'] = 'brew update; brew upgrade --ignore-pinned; brew cleanup; brew doctor'
fn b [@a]{ brew $@a }
fn brew-dump { brew bundle dump --file ~/Projects/dotfiles/brew/Brewfile --force }

# Docker
edit:small-word-abbr['doc'] = 'docker'
edit:small-word-abbr['docc'] = 'docker-compose'
edit:small-word-abbr['docps'] = 'docker ps -a'
edit:small-word-abbr['docrm'] = 'docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f'
edit:small-word-abbr['docrmi'] = 'docker rmi -f (docker images -a -q)'
edit:small-word-abbr['docstop'] = 'docker stop (docker ps -a -q)'

# Dotnet
edit:small-word-abbr['dotfmt'] = 'dotnet format'
edit:small-word-abbr['dotfsi'] = 'dotnet fsi'
edit:small-word-abbr['dotr'] = 'dotnet run'
edit:small-word-abbr['dott'] = 'dotnet test'
edit:small-word-abbr['dotup'] = 'dotnet outdated --upgrade'
fn dot [@a]{ dotnet $@a }
fn dot-tup { dotnet tool list -g | from-lines | drop 2 | each [l]{ str:split ' ' $l | take 1 } | each [l]{ dotnet tool update -g $l }}

# Edit
fn e [@a]{ nvim $@a }
fn ed [@a]{ nvim -d $@a }
fn en [@a]{ nvim -u NONE $@a }
fn er [@a]{ nvim -MR $@a }

# File System
fn c [@a]{ bat $@a }
fn dir-size { du -h -d 1 | sort -hr }
fn file-rmi { fd . --hidden --max-depth 1 --no-ignore | from-lines | each [f]{ put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Remove File' &accept=[f]{ rm -rf $f } }
fn file-yi { rg --files | from-lines | each [f]{ put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Yank File' &accept=[f]{ cat $f | pbcopy } }
fn l [@a]{ exa -al $@a }

# Git
edit:small-word-abbr['gcfg'] = 'git config --list --show-origin'
edit:small-word-abbr['gco'] = 'git checkout'
edit:small-word-abbr['gfa'] = 'git fetch --all'
edit:small-word-abbr['gi'] = 'lazygit'
edit:small-word-abbr['gl'] = "git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d' -100"
edit:small-word-abbr['gph'] = 'git push'
edit:small-word-abbr['gphf'] = 'git push --force'
edit:small-word-abbr['gs'] = 'git status -s'
edit:small-word-abbr['gunstage'] = 'git reset HEAD --'
fn g [@a]{ git $@a }

# Keyboard
fn karabiner-dump { cp ~/.config/karabiner/karabiner.json ~/Projects/dotfiles/karabiner }
fn karabiner-load { cp ~/Projects/dotfiles/karabiner/karabiner.json ~/.config/karabiner/karabiner.json }

# Makefile
fn m [@a]{ make $@a }

# Network
fn scan { nmap -sP 192.168.1.0/24 }

# Node.js
edit:small-word-abbr['nci'] = 'npm ci'
edit:small-word-abbr['ni'] = 'npm install'
edit:small-word-abbr['nlg'] = 'npm list -g --depth=0'
edit:small-word-abbr['nr'] = 'npm run'
edit:small-word-abbr['ns'] = "cat package.json | jq '.scripts'"
edit:small-word-abbr['nupg'] = 'npm update -g'
edit:small-word-abbr['nupi'] = 'npx npm-check-updates --deep -i'
edit:small-word-abbr['yupi'] = 'yarn upgrade-interactive'
fn n [@a]{ npm $@a }
fn nsi {
  scripts = (cat package.json | from-json | put (one)[scripts])
  keys $scripts | each [k]{ put [&to-filter=$k &to-accept=$k &to-show=(echo $k': '$scripts[$k])] } | edit:listing:start-custom [(all)] &caption='npm run' &accept=[s]{ npm run $s }
}
fn node-clean { fd -HI --prune node_modules | from-lines | peach [d]{ rm -rf $d } }
fn y [@a]{ yarn $@a }

# PostgreSQL
fn pg-up { postgres -D /usr/local/var/postgres }
fn pg-reset { brew uninstall --ignore-dependencies postgresql; rm -rf /usr/local/var/postgres; brew install postgresql; /usr/local/bin/timescaledb_move.sh }
fn pg-upgrade { brew postgresql-upgrade-database }

# Python
edit:small-word-abbr['po'] = 'poetry'
edit:small-word-abbr['posetup'] = 'poetry init; poetry add --dev black mypy pylint'
edit:small-word-abbr['py'] = 'python'

# Pulumi
edit:small-word-abbr['pu'] = 'pulumi'
edit:small-word-abbr['pud'] = 'pulumi destroy'
edit:small-word-abbr['puds'] = 'pulumi destroy --skip-preview'
edit:small-word-abbr['pup'] = 'pulumi preview'
edit:small-word-abbr['puso'] = 'pulumi stack output --show-secrets'
edit:small-word-abbr['puu'] = 'pulumi up'
edit:small-word-abbr['puus'] = 'pulumi up --skip-preview'
fn pusdi { pulumi stack export | from-json | put (one)[deployment][resources] | drop 0 (one) | each [r]{ put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } | edit:listing:start-custom [(all)] &caption='Pulumi Delete Resource' &accept=[r]{ pulumi state delete $r } }
fn pussi { pulumi stack ls --json | from-json | drop 0 (all) | each [s]{ put [&to-filter=$s[name] &to-accept=$s[name] &to-show=(if (eq $s[current] $true) { put (styled $s[name] green) } else { put $s[name] })] } | edit:listing:start-custom [(all)] &caption='Pulumi Stack' &accept=[s]{ pulumi stack select $s } }

# SSH
fn ssh-trust [@a]{ ssh-copy-id -i ~/.ssh/id_rsa.pub $@a }

# VSCode
edit:small-word-abbr['c.'] = 'code .'
fn code-ex-dump { code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt" }
fn code-ex-install { xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension }

# Web Browser
fn webbrowser { rm -rf /tmp/chrome_dev_test; /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:4200" }

