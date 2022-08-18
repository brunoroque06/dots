use math
use path
use readline-binding
use store
use str

set paths = [
  $E:HOME/bin
  /opt/homebrew/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/share/dotnet
  $E:HOME/.dotnet/tools
]
var _paths = $nil

set E:BAT_STYLE = plain
set E:BAT_THEME = ansi
set E:DOCKER_DEFAULT_PLATFORM = linux/amd64
set E:EDITOR = /opt/homebrew/bin/nvim
set E:JAVA_HOME = /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home
set E:LS_COLORS = (vivid generate $E:HOME/.config/vivid/theme.yml)
set E:MOAR = '-no-linenumbers -statusbar=bold -style=friendly'
set E:PAGER = /opt/homebrew/bin/moar
set E:RIPGREP_CONFIG_PATH = $E:HOME/.config/ripgreprc
set E:VISUAL = /opt/homebrew/bin/nvim
# set E:REQUESTS_CA_BUNDLE = $E:HOME/.proxyman/proxyman-ca.pem # proxyman with python

var _dur = 0
var _err = $false

set edit:after-command = [{ |m| set _dur = $m[duration] } { |m| set _err = (not-eq $m[error] $nil) }]

set edit:prompt = {
  var err = (if (put $_err) { put red } else { put blue })
  styled ' ' $err inverse

  if (not-eq $_paths $nil) { put ' *' }

  tilde-abbr $pwd | styled ' '(one) blue

  if (> $_dur 5) {
    var m = (/ $_dur 60 | math:floor (one))
    if (> $m 0) {
      printf ' %.0fm' $m | styled (one) yellow
    }
    var s = (math:floor $_dur | printf '%.0f' (one) | % (one) 60)
    printf ' %.0fs' $s | styled (one) yellow
  }

  styled ' ~> ' magenta
}
set edit:rprompt = (constantly (whoami)@(hostname))

eval (carapace _carapace | slurp)

if (path:is-regular &follow-symlink=$true $E:HOME/.config/elvish/lib/asdf.elv | not (one)) {
  mkdir -p $E:HOME/.config/elvish/lib
  ln -s /opt/homebrew/opt/asdf/libexec/asdf.elv $E:HOME/.config/elvish/lib/asdf.elv
}
set E:ASDF_DIR = /opt/homebrew/opt/asdf/libexec
set E:ASDF_DATA_DIR = $E:HOME/.asdf
use asdf _asdf
var asdf~ = $_asdf:asdf~
set edit:completion:arg-completer[asdf] = $_asdf:arg-completer~

# Azure
fn az-act-set { |s| az account set --subscription $s }
set edit:completion:arg-completer[az-act-set] = { |@args|
  az account list ^
    | from-json ^
    | all (one) ^
    | each { |s| edit:complex-candidate $s[id] &display=(if (put $s[isDefault]) { styled $s[name] green } else { put $s[name] }) }
}

# Bazel
fn bzl-setup {
  var dir = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
  mkdir -p $dir
  ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk $dir
}

# Command
fn cmd-edit {
  var tmp = (path:temp-file '*.elv')
  print $edit:current-command > $tmp
  try {
    $E:EDITOR $tmp[name] </dev/tty >/dev/tty 2>&1
    set edit:current-command = (slurp < $tmp[name])[..-1]
  } catch {
    file:close $tmp
  }
  rm $tmp[name]
}

# Docker
fn doc-cnt-rm { docker stop (docker ps -aq); docker rm (docker ps -aq) }
fn doc-cnt-stop { docker stop (docker ps -aq) }
fn doc-exec { |cnt| docker exec -it $cnt bash }
set edit:completion:arg-completer[doc-exec] = { |@args|
  docker ps --format "{{.Image}} {{.Names}}" ^
    | from-lines ^
    | each { |cnt| var c = (str:split ' ' $cnt | put [(all)]); put [&img=$c[0] &name=$c[1]] } ^
    | each { |cnt| edit:complex-candidate &display=$cnt[name]' ('$cnt[img]')' $cnt[name] }
}
fn doc-img-rm { docker rmi -f (docker images -aq) }
fn doc-prune { docker system prune --volumes -f }
fn doc-setup {
  var cfg = $E:HOME/.docker/config.json
  var kc = (cat $cfg | from-json)
  assoc $kc credsStore osxkeychain | to-json > $cfg
}

# Dotnet
fn dot-up { dotnet outdated --upgrade }

# File System
fn p { |f|
  if (str:has-suffix $f .md) {
    glow -p $f
  } else {
    bat $f
  }
}
fn dir-size { dust -d 1 }
fn e { |@a| $E:EDITOR $@a }
fn en { |@a| $E:EDITOR -u NONE $@a }
fn rmr { |f| rm -fr $f }
set edit:completion:arg-completer[rmr] = { |@args|
  fd . --hidden --max-depth 1 --no-ignore --strip-cwd-prefix ^
    | from-lines
}
fn file-yank { |f| cat $f pbcopy }
set edit:completion:arg-completer[file-yank] = { |@args|
  rg --files ^
    | from-lines
}
fn file-unix { |f|
  var con = (cat $f | from-lines | put [(all)])
  rm $f
  touch $f
  each { |l| echo $l >> $f } $con
}
fn l { |@a| exa -al --git --no-permissions $@a }
fn r { |@a| $E:EDITOR -R $@a }
fn rn { |@a| $E:EDITOR -R -u NONE $@a }
fn t { |&l=2 @d|
  exa -al --git --level $l --no-permissions --tree $@d
}

# Git
fn git-cfg { git config --list --show-origin }
fn gd { git diff }
fn gs { git status -s }
fn gl { |&c=10| git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim)- %an%C(auto)%d' -$c }

# JetBrains
fn jb-clean { |a|
  var dirs = ['Application Support/JetBrains' 'Caches/JetBrains' 'Logs/JetBrains']
  for d $dirs {
    rm -fr $E:HOME/Library/$d/$a
  }
}
set edit:completion:arg-completer[jb-clean] = { |@args|
  ls $E:HOME/Library/Caches/JetBrains | from-lines
}

# Network
fn ntw-scan { nmap -sP 192.168.1.0/24 }

# Node.js
fn npm-up { npm-check-updates --deep -i }
fn node-clean {
  fd -HI --prune node_modules ^
    | from-lines ^
    | peach { |d| rm -fr $d }
}

# Packages
fn brew-dump { brew bundle dump --file $E:HOME/Projects/dotfiles/brew/Brewfile --force }
fn brew-up {
  brew update; brew upgrade --ignore-pinned; brew cleanup
  try { brew doctor } catch { }
}
fn pkg-up {
  brew-up

  put dotnet-outdated-tool dotnet-fsharplint fantomas-tool ^
    | each { |p| try { dotnet tool install -g $p } catch { } }
  dotnet tool list -g ^
    | from-lines ^
    | drop 2 ^
    | each { |l| str:split ' ' $l | take 1 } ^
    | each { |p| dotnet tool update -g $p }

  npm install -g ^
    dockerfile-language-server-nodejs ^
    npm ^
    npm-check-updates ^
    paperspace-node ^
    typescript-language-server ^
    vscode-langservers-extracted
  npm-check-updates -g
}

# PostgreSQL
fn pg-up { postgres -D /usr/local/var/postgres }
fn pg-reset { brew uninstall --ignore-dependencies postgresql; rm -fr /usr/local/var/postgres; brew install postgresql; /usr/local/bin/timescaledb_move.sh }
fn pg-upgrade { brew postgresql-upgrade-database }

# Python
fn py-act {
  if (not-eq $_paths $nil) {
    fail 'A venv is already active'
  }
  var venv = $E:PWD/venv/bin
  if (path:is-dir $venv | not (one)) {
    fail 'No venv found'
  }
  set _paths = $paths
  set paths = [$venv $@paths]
}
fn py-dea {
  if (eq $_paths $nil) {
    fail 'No venv is active'
  }
  set paths = $_paths
  set _paths = $nil
}
fn py-setup {
  python -m venv venv
  py-act
  pip install --upgrade pip
  pip install -r requirements.txt
}
fn py-up { py-act; pip install pur; pur; py-dea }

# Pulumi
fn pu-res { |@args|
  pulumi stack export ^
    | from-json ^
    | put (one)[deployment][resources] ^
    | each { |r| put $r[urn] } (one)
}
fn pu-res-del { |r| pulumi state delete $r }
set edit:completion:arg-completer[pu-res-del] = $pu-res~
fn pu-res-des { |r| pulumi destroy -t $r }
set edit:completion:arg-completer[pu-res-des] = $pu-res~
fn pu-res-ls {
  pulumi stack export ^
    | from-json ^
    | all (one)[deployment][resources] ^
    | put (all)[urn]
}
fn pu-stk-sel { |s| pulumi stack select $s }
set edit:completion:arg-completer[pu-stk-sel] = { |@args|
  pulumi stack ls --json ^
    | from-json ^
    | all (one) ^
    | each { |s| edit:complex-candidate $s[name] &display=(if (put $s[current]) { styled $s[name] green } else { put $s[name] }) }
}

# Shell
fn env-ls {
  env -0 ^
    | from-terminated "\x00" ^
    | each { |e| var k v = (str:split &max=2 = $e); put [$k $v] } ^
    | order
}
fn colortest { curl -s https://raw.githubusercontent.com/pablopunk/colortest/master/colortest | bash }
fn reload { exec elvish -sock $E:HOME/.local/state/elvish/sock }

# SSH
fn ssh-trust { |@a| ssh-copy-id -i $E:HOME/.ssh/id_rsa.pub $@a }

# VSCode
fn code-ext-dump { code --list-extensions > $E:HOME'/Library/Application Support/Code/User/extensions.txt' }
fn code-ext-install { xargs < $E:HOME'/Library/Application Support/Code/User/extensions.txt' -L 1 code --force --install-extension }

# Web Browser
fn webbrowser { rm -fr $E:TMPDIR/webbrowser; '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --user-data-dir=$E:TMPDIR/webbrowser --disable-web-security --incognito --no-first-run --new-window http://localhost:4200 }

# Taken: a, b, f, e, i, n, p
set edit:insert:binding[Ctrl-d] = $edit:navigation:start~
set edit:insert:binding[Ctrl-l] = $edit:location:start~
set edit:insert:binding[Ctrl-o] = $edit:lastcmd:start~
set edit:insert:binding[Ctrl-r] = $edit:histlist:start~
set edit:insert:binding[Ctrl-t] = $cmd-edit~
set edit:insert:binding[Ctrl-y] = {
  fd --hidden --strip-cwd-prefix . ^
    | from-lines ^
    | each { |f| put [&to-accept=$f &to-filter=$f &to-show=$f] } ^
    | edit:listing:start-custom &caption='Files' &accept={ |f| edit:insert-at-dot $f } [(all)]
}
set edit:insert:binding[Ctrl-w] = $edit:kill-small-word-left~
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

