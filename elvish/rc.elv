use math
use path
use readline-binding
use store
use str

set E:BAT_STYLE = auto
set E:BAT_THEME = GitHub
set E:DOCKER_DEFAULT_PLATFORM = linux/amd64
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

var _duration = 0
set edit:after-command = [{ |m| set _duration = $m[duration] }]

set edit:prompt = {
  if (not-eq $_paths $nil) {
    put '* '
  }
  styled (tilde-abbr $pwd) blue
  if (> $_duration 5) {
    var m = (/ $_duration 60 | math:floor (one))
    if (> $m 0) {
      printf ' %.0fm' $m | styled (one) yellow
    }
    var s = (math:floor $_duration | printf '%.0f' (one) | % (one) 60)
    printf ' %.0fs' $s | styled (one) yellow
  }
  styled ' ~> ' magenta
}
set edit:rprompt = (constantly (whoami)@(hostname))

set edit:insert:binding[Ctrl-d] = $edit:navigation:start~
set edit:insert:binding[Ctrl-l] = $edit:location:start~
set edit:insert:binding[Ctrl-o] = $edit:lastcmd:start~
set edit:insert:binding[Ctrl-r] = $edit:histlist:start~
set edit:insert:binding[Ctrl-w] = $edit:kill-small-word-left~
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

eval (carapace _carapace | slurp) # https://github.com/rsteube/carapace-bin

if (path:is-regular &follow-symlink=$true $E:HOME/.config/elvish/lib/asdf.elv | not (one)) {
  mkdir -p $E:HOME/.config/elvish/lib
  ln -s /opt/homebrew/opt/asdf/libexec/asdf.elv $E:HOME/.config/elvish/lib/asdf.elv
}
set E:ASDF_DIR = /opt/homebrew/opt/asdf/libexec/
use asdf _asdf; var asdf~ = $_asdf:asdf~
set edit:completion:arg-completer[asdf] = $_asdf:arg-completer~

fn map { |f l| each { |i| $f $i } $l | put [(all)] }

# Azure
fn az-account-set { az account list | from-json | map { |s| put [&to-filter=$s[name] &to-accept=$s[id] &to-show=(if (eq $s[isDefault] $true) { put (styled $s[name] green) } else { put $s[name] })] } (one) | edit:listing:start-custom (one) &caption='Azure Subscription' &accept={ |s| az account set --subscription $s > /dev/tty } }

# Bazel
fn bazel-macossdk {
  var dir = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
  mkdir -p $dir
  ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk $dir
}

# Brew
fn brew-dump { brew bundle dump --file $E:HOME/Projects/dotfiles/brew/Brewfile --force }
fn brew-up { brew update; brew upgrade --ignore-pinned; brew cleanup; brew doctor }

# Command
fn cmd-del { store:cmds 0 -1 | each { |c| put [&to-filter=$c[text] &to-accept=""$c[seq] &to-show=$c[text]] } | edit:listing:start-custom [(all)] &caption='Delete Command' &accept={ |c| store:del-cmd $c } }
fn cmd-yank { store:cmds 0 -1 | each { |c| put [&to-filter=$c[text] &to-accept=$c[text] &to-show=$c[text]] } | edit:listing:start-custom [(all)] &caption='Yank Command' &accept={ |c| printf $c | pbcopy } }

# Docker
fn doc { |@a| docker $@a }
fn doc-container-rm { docker stop (docker ps -aq); docker rm (docker ps -aq); docker system prune --volumes -f }
fn doc-container-stop { docker stop (docker ps -aq) }
fn doc-image-rm { docker rmi -f (docker images -aq) }
fn doc-setup {
  var config = $E:HOME/.docker/config.json
  var keychain = (cat $config | from-json)
  assoc $keychain credsStore osxkeychain | to-json | jq > $config
}

# Dotnet
fn dot { |@a| dotnet $@a }
fn dot-up { dotnet outdated --upgrade }
fn dot-tool-up { dotnet tool list -g | from-lines | drop 2 | each { |l| str:split ' ' $l | take 1 } | each { |l| dotnet tool update -g $l } }

# Environment
fn env-ls { env | from-lines | each { |e| var k v = (str:split '=' $e); put [$k $v] } | order }

# File System
fn dir-size { dust -d 1 }
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

# Files
fn e { |@a| nvim $@a }
fn file-rmrf { fd . --hidden --max-depth 1 --no-ignore | from-lines | each { |f| put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Remove File' &accept={ |f| rm -rf $f } }
fn file-yank { rg --files | from-lines | each { |f| put [&to-filter=$f &to-accept=$f &to-show=$f] } | edit:listing:start-custom [(all)] &caption='Yank File' &accept={ |f| cat $f | pbcopy } }
fn r { |@a| nvim -R $@a }
fn rn { |@a| nvim -R -u NONE $@a }

# Git
fn git-config { git config --list --show-origin }
fn gl { git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim white)- %an %C(auto)%d' -100 }
fn gi { lazygit }

# JetBrains
fn jetbrains-clean { |a|
  var dirs = ['Application Support/JetBrains' 'Caches/JetBrains' 'Logs/JetBrains']
  for d $dirs {
    rm -rf $E:HOME/Library/$d/$a
  }
}
set edit:completion:arg-completer[jetbrains-clean] = { |@args|
  ls $E:HOME/'Library/Application Support/JetBrains' | from-lines
}

# Network
fn network-scan { nmap -sP 192.168.1.0/24 }

# Node.js
fn npm-up { npx npm-check-updates --deep -i }
fn node-clean { fd -HI --prune node_modules | from-lines | peach { |d| rm -rf $d } }
fn yarn-up { yarn upgrade-interactive }

# PostgreSQL
fn pg-up { postgres -D /usr/local/var/postgres }
fn pg-reset { brew uninstall --ignore-dependencies postgresql; rm -rf /usr/local/var/postgres; brew install postgresql; /usr/local/bin/timescaledb_move.sh }
fn pg-upgrade { brew postgresql-upgrade-database }

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
fn pu-stack-select { pulumi stack ls --json | from-json | map { |s| put [&to-filter=$s[name] &to-accept=$s[name] &to-show=(if (eq $s[current] $true) { put (styled $s[name] green) } else { put $s[name] })] } (one) | edit:listing:start-custom (one) &caption='Pulumi Stack' &accept={ |s| pulumi stack select $s > /dev/tty } }
fn pu-resource-delete { pulumi stack export | from-json | put (one)[deployment][resources] | map { |r| put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } (one) | edit:listing:start-custom (one) &caption='Pulumi Delete Resource' &accept={ |r| pulumi state delete $r > /dev/tty } }
fn pu-resource-yank { pulumi stack export | from-json | put (one)[deployment][resources] | map { |r| put [&to-filter=$r[urn] &to-accept=$r[urn] &to-show=$r[urn]] } (one) | edit:listing:start-custom (one) &caption='Pulumi Yank Resource' &accept={ |r| echo $r } }

# SSH
fn ssh-trust { |@a| ssh-copy-id -i $E:HOME/.ssh/id_rsa.pub $@a }

# VSCode
fn code-open { code . }
fn code-extension-dump { code --list-extensions > $E:HOME'/Library/Application Support/Code/User/extensions.txt' }
fn code-extension-install { xargs < $E:HOME'/Library/Application Support/Code/User/extensions.txt' -L 1 code --force --install-extension }

# Web Browser
fn webbrowser { rm -rf $E:TMPDIR/webbrowser; '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --user-data-dir=$E:TMPDIR/webbrowser --disable-web-security --incognito --no-first-run --new-window http://localhost:4200 }

