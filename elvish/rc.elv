use path
use readline-binding
use str

set E:BAT_STYLE = auto
set E:BAT_THEME = 1337
set E:EDITOR = nvim
set E:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
set E:PAGER = less
set E:RIPGREP_CONFIG_PATH = ~/.config/ripgreprc
set E:VISUAL = nvim

set paths = [
  ~/.asdf/shims
  /opt/homebrew/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/share/dotnet
  ~/.dotnet/tools
]

set edit:prompt = { styled (tilde-abbr $pwd) blue; put (styled ' Λ ' magenta) }
set edit:rprompt = (constantly (whoami)@(hostname))

# set edit:insert:binding["Ctrl-["] = { edit:command:start }
set edit:insert:binding['Ctrl-d'] = { edit:navigation:start }
set edit:insert:binding['Ctrl-l'] = { edit:location:start }
set edit:insert:binding['Ctrl-o'] = { edit:lastcmd:start }
set edit:insert:binding['Ctrl-r'] = { edit:histlist:start }

set edit:command:binding['a'] = { edit:move-dot-right; edit:close-mode }
set edit:command:binding['A'] = { edit:move-dot-eol; edit:close-mode }
set edit:command:binding['C'] = { edit:kill-line-right; edit:close-mode }
set edit:command:binding['I'] = { edit:move-dot-sol; edit:close-mode }
set edit:command:binding['s'] = { edit:move-dot-right; edit:kill-rune-left; edit:close-mode }
set edit:command:binding['x'] = { edit:move-dot-right; edit:kill-rune-left }

eval (carapace _carapace | slurp)

# if (path:is-regular &follow-symlink=$true ~/.elvish/lib/asdf.elv | not (one)) {
#   mkdir -p ~/.elvish/lib
#   ln -s /opt/homebrew/opt/asdf/libexec/asdf.elv ~/.elvish/lib/asdf.elv
# }
# use asdf _asdf; fn asdf {|@args| _asdf:asdf $@args}

# Azure
fn az-account-set { az account list | from-json | drop 0 (one) | each {|s| put [&to-filter=$s[name] &to-accept=$s[id] &to-show=(if (eq $s[isDefault] $true) { put (styled $s[name] green) } else { put $s[name] })] } | edit:listing:start-custom [(all)] &caption='Azure Subscription' &accept={|s| az account set --subscription $s > /dev/tty } }

# Brew
set edit:small-word-abbr['b'] = 'brew'
set edit:small-word-abbr['bi'] = 'brew install'
set edit:small-word-abbr['bl'] = 'brew leaves'
set edit:small-word-abbr['blc'] = 'brew leaves --cask -1'
fn brew-dump { brew bundle dump --file ~/Projects/dotfiles/brew/Brewfile --force }
fn brew-up { brew update; brew upgrade --ignore-pinned; brew cleanup; brew doctor }

# Docker
set edit:small-word-abbr['doc'] = 'docker'
set edit:small-word-abbr['docc'] = 'docker-compose'
set edit:small-word-abbr['docps'] = 'docker ps -a'
fn docker-rm-container { docker stop (docker ps -a -q); docker rm (docker ps -a -q); docker system prune --volumes -f }
fn docker-rm-image { docker rmi -f (docker images -a -q) }
fn docker-stop-container { docker stop (docker ps -a -q) }

# Dotnet
set edit:small-word-abbr['dot'] = 'dotnet'
set edit:small-word-abbr['dotfmt'] = 'dotnet format'
set edit:small-word-abbr['dotfsi'] = 'dotnet fsi'
set edit:small-word-abbr['dotr'] = 'dotnet run'
set edit:small-word-abbr['dott'] = 'dotnet test'
set edit:small-word-abbr['dotup'] = 'dotnet outdated --upgrade'
fn dotnet-tool-up { dotnet tool list -g | from-lines | drop 2 | each {|l| str:split ' ' $l | take 1 } | each {|l| dotnet tool update -g $l }}

# Edit
set edit:small-word-abbr['e'] = 'nvim'
set edit:small-word-abbr['ed'] = 'nvim -d'
set edit:small-word-abbr['en'] = 'nvim -u NONE'
set edit:small-word-abbr['er'] = 'nvim -MR'

# File System
set edit:small-word-abbr['l'] = 'exa -al'
fn dir-size { du -h -d 1 | sort -hr }
fn file-backup {|f| cp $f "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" }
fn file-rmrf { fd . --hidden --max-depth 1 --no-ignore | from-lines | each {|f| put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Remove File' &accept={|f| rm -rf $f } }
fn file-yi { rg --files | from-lines | each {|f| put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Yank File' &accept={|f| cat $f | pbcopy } }
fn p {|p|
  if (path:is-dir $p) {
    exa --tree --level 3 $p
  } elif (str:has-suffix $p .md) {
    glow $p
  } else {
    bat $p
  }
}

# Git
set edit:small-word-abbr['g'] = 'git'
set edit:small-word-abbr['gi'] = 'lazygit'
set edit:small-word-abbr['gl'] = "git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d' -100"
set edit:small-word-abbr['gph'] = 'git push'
set edit:small-word-abbr['gphf'] = 'git push --force'
set edit:small-word-abbr['gs'] = 'git status -s'
set edit:small-word-abbr['gunstage'] = 'git reset HEAD --'
fn git-config { git config --list --show-origin }

# Network
fn network-scan { nmap -sP 192.168.1.0/24 }

# Node.js
set edit:small-word-abbr['n'] = 'npm'
set edit:small-word-abbr['nci'] = 'npm ci'
set edit:small-word-abbr['ni'] = 'npm install'
set edit:small-word-abbr['nlg'] = 'npm list -g --depth=0'
set edit:small-word-abbr['nr'] = 'npm run'
set edit:small-word-abbr['ns'] = 'cat package.json | from-json | put (one)[scripts] | pprint (one)'
set edit:small-word-abbr['nupg'] = 'npm update -g'
fn nri {
  var scripts = (cat package.json | from-json | put (one)[scripts])
  keys $scripts | each {|k| put [&to-filter=$k &to-accept=$k &to-show=(echo $k': '$scripts[$k])] } | edit:listing:start-custom [(all)] &caption='npm run' &accept={|s| npm run $s > /dev/tty }
}
fn npm-up { npx npm-check-updates --deep -i }
fn node-clean { fd -HI --prune node_modules | from-lines | peach {|d| rm -rf $d } }
fn yarn-up { yarn upgrade-interactive }

# PostgreSQL
fn postgresql-up { postgres -D /usr/local/var/postgres }
fn postgresql-reset { brew uninstall --ignore-dependencies postgresql; rm -rf /usr/local/var/postgres; brew install postgresql; /usr/local/bin/timescaledb_move.sh }
fn postgresql-upgrade { brew postgresql-upgrade-database }

# Python
set edit:small-word-abbr['py'] = 'python'
set edit:small-word-abbr['python-setup'] = 'asdf shell python 3.9.9 && python -m venv venv && source venv/bin/activate.fish && pip install -r requirements.txt'

# Pulumi
set edit:small-word-abbr['pu'] = 'pulumi'
set edit:small-word-abbr['pud'] = 'pulumi destroy'
set edit:small-word-abbr['puds'] = 'pulumi destroy --skip-preview'
set edit:small-word-abbr['pup'] = 'pulumi preview'
set edit:small-word-abbr['puso'] = 'pulumi stack output --show-secrets'
set edit:small-word-abbr['puu'] = 'pulumi up'
set edit:small-word-abbr['puus'] = 'pulumi up --skip-preview'
fn pulumi-stack-select { pulumi stack ls --json | from-json | drop 0 (all) | each {|s| put [&to-filter=$s[name] &to-accept=$s[name] &to-show=(if (eq $s[current] $true) { put (styled $s[name] green) } else { put $s[name] })] } | edit:listing:start-custom [(all)] &caption='Pulumi Stack' &accept={|s| pulumi stack select $s > /dev/tty } }
fn pulumi-resource-delete { pulumi stack export | from-json | put (one)[deployment][resources] | drop 0 (one) | each {|r| put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } | edit:listing:start-custom [(all)] &caption='Pulumi Delete Resource' &accept={|r| pulumi state delete $r > /dev/tty } }
fn pulumi-resource-yank { pulumi stack export | from-json | put (one)[deployment][resources] | drop 0 (one) | each {|r| put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } | edit:listing:start-custom [(all)] &caption='Pulumi Yank Resource' &accept={|r| echo $r } }

# SSH
fn ssh-trust {|@a| ssh-copy-id -i ~/.ssh/id_rsa.pub $@a }

# VSCode
set edit:small-word-abbr['c.'] = 'code .'
fn code-extension-dump { code --list-extensions > "$HOME/Library/Application Support/Code/User/extensions.txt" }
fn code-extension-install { xargs <"$HOME/Library/Application Support/Code/User/extensions.txt" -L 1 code --force --install-extension }

# Web Browser
fn webbrowser { rm -rf /tmp/chrome_dev_test; /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:4200" }

