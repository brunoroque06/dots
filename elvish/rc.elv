use path
use readline-binding
use store
use str

set E:BAT_STYLE = auto
set E:BAT_THEME = 1337
# set E:DOCKER_DEFAULT_PLATFORM = linux/amd64 # good idea?
set E:EDITOR = nvim
set E:RIPGREP_CONFIG_PATH = $E:HOME/.config/ripgreprc
set E:VISUAL = nvim
# set E:REQUESTS_CA_BUNDLE = $E:HOME/.proxyman/proxyman-ca.pem # proxyman with python

set paths = [
  $E:HOME/.asdf/shims
  /opt/homebrew/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/share/dotnet
  $E:HOME/bin
  $E:HOME/.dotnet/tools
]
var _paths

set edit:prompt = {
  if (not-eq $_paths $nil) {
    put '* '
  }
  styled (tilde-abbr $pwd) blue
  put (styled ' ~> ' magenta)
}
set edit:rprompt = (constantly (whoami)@(hostname))

set edit:insert:binding['Ctrl-d'] = { edit:navigation:start }
set edit:insert:binding['Ctrl-l'] = { edit:location:start }
set edit:insert:binding['Ctrl-o'] = { edit:lastcmd:start }
set edit:insert:binding['Ctrl-r'] = { edit:histlist:start }

eval (carapace _carapace | slurp) # https://github.com/rsteube/carapace-bin

if (path:is-regular &follow-symlink=$true $E:HOME/.config/elvish/lib/asdf.elv | not (one)) {
  mkdir -p $E:HOME/.config/elvish/lib
  ln -s /opt/homebrew/opt/asdf/libexec/asdf.elv $E:HOME/.config/elvish/lib/asdf.elv
}
set E:ASDF_DIR = /opt/homebrew/opt/asdf/libexec/
use asdf _asdf; var asdf~ = $_asdf:asdf~
set edit:completion:arg-completer[asdf] = $_asdf:arg-completer~

# Azure
fn az-account-set { az account list | from-json | drop 0 (one) | each { |s| put [&to-filter=$s[name] &to-accept=$s[id] &to-show=(if (eq $s[isDefault] $true) { put (styled $s[name] green) } else { put $s[name] })] } | edit:listing:start-custom [(all)] &caption='Azure Subscription' &accept={ |s| az account set --subscription $s > /dev/tty } }

# Bazel
fn bazel-macossdk {
  var dir = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
  mkdir -p $dir
  ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk $dir
}

# Brew
fn brew-dump { brew bundle dump --file $E:HOME/Projects/dotfiles/brew/Brewfile --force }
fn brew-up { brew update; brew upgrade --ignore-pinned; brew cleanup; brew doctor }

# Docker
fn doc { |@a| docker $@a }
fn docker-ps { |@a| docker ps -a $@a }
fn docker-rm-container { docker stop (docker ps -aq); docker rm (docker ps -aq); docker system prune --volumes -f }
fn docker-rm-image { docker rmi -f (docker images -aq) }
fn docker-stop-container { docker stop (docker ps -aq) }
fn limactl-config {
  # /opt/homebrew/Cellar/lima/0.9.1/share/lima/examples/default.yaml
  nvim $E:HOME/.lima/_config/default.yaml
}
fn limactl-setup {
  var exists = (limactl ls --json | from-json | each { |v| put $v[name] } | has-value [(all)] default)
  if (eq $exists $true) {
    limactl start default
  } else {
    limactl start --name=default template://docker
  }
  docker context update lima --docker 'host=unix://'$E:HOME'/.lima/default/sock/docker.sock'
  docker context use lima
  var config = $E:HOME/.docker/config.json
  var keychain = (cat $config | from-json)
  assoc $keychain credsStore osxkeychain | to-json | jq > $config
}

# Dotnet
fn dot { |@a| dotnet $@a }
fn dotnet-up { dotnet outdated --upgrade }
fn dotnet-tool-up { dotnet tool list -g | from-lines | drop 2 | each { |l| str:split ' ' $l | take 1 } | each { |l| dotnet tool update -g $l }}

# Edit
fn e { |@a| nvim $@a }

# Environment
fn env-ls { env | from-lines | each { |e| var k v = (str:split '=' $e); put [$k $v] } | order }
fn cmd-del { store:cmds 0 -1 | each { |c| put [&to-filter=$c[text] &to-accept=""$c[seq] &to-show=$c[text]] } | edit:listing:start-custom [(all)] &caption='Delete Command' &accept={ |c| store:del-cmd $c } }

# File System
fn dir-size { dust -d 1 }
fn file-backup { |f| cp $f $E:HOME'/Library/Mobile Documents/com~apple~CloudDocs/' }
fn file-rmrf { fd . --hidden --max-depth 1 --no-ignore | from-lines | each { |f| put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Remove File' &accept={ |f| rm -rf $f } }
fn file-yank { rg --files | from-lines | each { |f| put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Yank File' &accept={ |f| cat $f | pbcopy } }
fn l { |@a| exa -al $@a }
fn p { |p|
  if (path:is-dir $p) {
    exa -al $p
  } elif (str:has-suffix $p .md) {
    glow $p
  } else {
    bat $p
  }
}

# Git
fn git-config { git config --list --show-origin }
fn gl { git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d' -100 }
fn gi { lazygit }

# Network
fn network-scan { nmap -sP 192.168.1.0/24 }

# Node.js
fn npm-up { npx npm-check-updates --deep -i }
fn node-clean { fd -HI --prune node_modules | from-lines | peach { |d| rm -rf $d } }
fn yarn-up { yarn upgrade-interactive }

# PostgreSQL
fn postgresql-up { postgres -D /usr/local/var/postgres }
fn postgresql-reset { brew uninstall --ignore-dependencies postgresql; rm -rf /usr/local/var/postgres; brew install postgresql; /usr/local/bin/timescaledb_move.sh }
fn postgresql-upgrade { brew postgresql-upgrade-database }

# Python
set edit:small-word-abbr['python-setup'] = 'asdf shell python 3.9.9; python -m venv venv; activate; pip install --upgrade pip; pip install -r requirements.txt'
fn activate {
  var venv = $E:PWD/venv/bin
  if (path:is-dir $venv | not (one)) {
    fail 'No virtual environment detected'
  }
  set _paths = $paths
  set paths = [$venv $@paths]
}
fn deactivate {
  if (eq $_paths $nil) {
    fail 'No virtual environment is active'
  }
  set paths = $_paths
  set _paths = $nil
}

# Pulumi
fn pu { |@a| pulumi $@a }
fn pulumi-stack-select { pulumi stack ls --json | from-json | drop 0 (all) | each { |s| put [&to-filter=$s[name] &to-accept=$s[name] &to-show=(if (eq $s[current] $true) { put (styled $s[name] green) } else { put $s[name] })] } | edit:listing:start-custom [(all)] &caption='Pulumi Stack' &accept={ |s| pulumi stack select $s > /dev/tty } }
fn pulumi-resource-delete { pulumi stack export | from-json | put (one)[deployment][resources] | drop 0 (one) | each { |r| put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } | edit:listing:start-custom [(all)] &caption='Pulumi Delete Resource' &accept={ |r| pulumi state delete $r > /dev/tty } }
fn pulumi-resource-yank { pulumi stack export | from-json | put (one)[deployment][resources] | drop 0 (one) | each { |r| put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } | edit:listing:start-custom [(all)] &caption='Pulumi Yank Resource' &accept={ |r| echo $r } }

# SSH
fn ssh-trust { |@a| ssh-copy-id -i $E:HOME/.ssh/id_rsa.pub $@a }

# VSCode
fn code-open { code . }
fn code-extension-dump { code --list-extensions > $E:HOME'/Library/Application Support/Code/User/extensions.txt' }
fn code-extension-install { xargs < $E:HOME'/Library/Application Support/Code/User/extensions.txt' -L 1 code --force --install-extension }

# Web Browser
fn webbrowser { rm -rf /tmp/chrome_dev_test; /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --incognito --no-first-run --new-window "http://localhost:4200" }

