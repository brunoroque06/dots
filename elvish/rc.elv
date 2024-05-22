use file
use math
use path
use readline-binding
use str

set paths = [
  /opt/homebrew/bin
  /opt/homebrew/opt/libpq/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $E:HOME/go/bin
  /usr/local/share/dotnet
  $E:HOME/.dotnet/tools
  $E:HOME/.paperspace/bin
  /Applications/Rider.app/Contents/MacOS
]
var _paths = $nil

set-env BAT_STYLE plain
set-env BAT_THEME ansi
# set-env DOCKER_DEFAULT_PLATFORM linux/amd64
set-env EDITOR /opt/homebrew/bin/vim
set-env LESS '-i --incsearch -m'
set-env PAGER /opt/homebrew/bin/less
# set-env REQUESTS_CA_BUNDLE $E:HOME/.proxyman/proxyman-ca.pem # proxyman with python
set-env RIPGREP_CONFIG_PATH $E:HOME/.config/ripgreprc
set-env VISUAL $E:EDITOR

fn osc { |c| print "\e]"$c"\a" }

fn send-title { |t| osc '0;'$t }

fn path { tilde-abbr $pwd | path:base (one) }

fn send-pwd {
  send-title (path)
  osc '7;'(put $pwd)
}

var _dur = 0
var _err = $false

set edit:after-command = [
  { |_| osc '133;A' }
  { |_| send-pwd }
  { |m| set _dur = $m[duration] }
  { |m| set _err = (not-eq $m[error] $nil) }
]

set edit:after-readline = [
  { |_| osc '133;C' }
  { |c| send-title (str:split ' ' $c | take 1) }
]

set after-chdir = [
  { |_| send-pwd }
]

set edit:prompt = {
  var err = (if (put $_err) { put red } else { put blue })
  styled ' ' $err inverse

  if (not-eq $_paths $nil) { put ' *' }

  styled ' '(path) blue

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

# Azure
fn az-act-set { |n| az account set -n $n }
set edit:completion:arg-completer[az-act-set] = { |@args|
  az account list ^
    | from-json ^
    | all (one) ^
    | each { |s| edit:complex-candidate $s[name] &display=(if (put $s[isDefault]) { styled $s[name] green } else { put $s[name] }) }
}

# Command
fn cmd-edit {
  var tmp = (path:temp-file '*.elv')
  print $edit:current-command > $tmp
  try {
    $E:EDITOR $tmp[name] <$path:dev-tty >$path:dev-tty 2>&1
    set edit:current-command = (slurp < $tmp[name] | str:trim-right (one) "\n")
  } catch {
    file:close $tmp
  }
  rm $tmp[name]
}

# D2
fn d2-fmt {
  ls ^
  | from-lines ^
  | each { |f| if (str:equal-fold (path:ext $f) .d2) { d2 fmt $f } }
}
fn d2-run {
  ls ^
  | from-lines ^
  | each { |f| if (str:equal-fold (path:ext $f) .d2) {
      d2 fmt $f
    }
  }
}

# Docker
fn doc-clean {
  docker rmi -f (docker images -aq)
  docker system prune --volumes -f
}
fn doc-cnt-rm {
  docker stop (docker ps -aq); docker rm (docker ps -aq)
}
fn doc-exec { |cnt| docker exec -it $cnt bash }
set edit:completion:arg-completer[doc-exec] = { |@args|
  docker ps --format '{{.Image}} {{.Names}}' ^
    | from-lines ^
    | each { |cnt| var c = (str:split ' ' $cnt | put [(all)]); put [&img=$c[0] &name=$c[1]] } ^
    | each { |cnt| edit:complex-candidate &display=$cnt[name]' ('$cnt[img]')' $cnt[name] }
}
fn doc-su {
  var cfg = $E:HOME/.docker/config.json
  var kc = (cat $cfg | from-json)
  assoc $kc credsStore osxkeychain | to-json > $cfg
}

# Dotnet
fn dot-csi { |@a| csharprepl -t themes/VisualStudio_Light.json $@a }
fn dot-fsi { |@a| dotnet fsi $@a }
fn dot-up { dotnet outdated --upgrade }
set edit:completion:arg-completer[dotnet] = { |@args|
	dotnet complete (str:join ' ' $args) | from-lines
}

# File System
fn p { |f|
  if (str:has-suffix $f .md) {
    glow $f
  } else {
    bat $f
  }
}
fn dir-size { dust -d 1 }
fn e { |@a| $E:EDITOR $@a }
fn fd { |@a| e:fd -c never $@a }
fn file-yank { |f| pbcopy < $f }
set edit:completion:arg-completer[file-yank] = { |@args|
  rg --files ^
    | from-lines
}
var _kitten = /Applications/kitty.app/Contents/MacOS/kitten
fn kitten { |@a| $_kitten $@a }
fn icat { |@a| $_kitten icat $@a }
fn l { |@a| eza -al --git --no-permissions $@a }
fn t { |&l=2 @d|
  eza -al --git --level $l --no-permissions --tree $@d
}

# Git
fn git-cfg { git config --list --show-origin }
fn gid { git diff }
fn gis { git status -s }
fn gil { |&c=10| git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim)- %an%C(auto)%d' -$c }

# Go
fn go-up { go get -u; go mod tidy }

# JetBrains
fn jb-rm { |a|
  var dirs = ['Application Support/JetBrains' 'Caches/JetBrains' 'Logs/JetBrains']
  for d $dirs {
    rm -rf $E:HOME/Library/$d/$a
  }
}
set edit:completion:arg-completer[jb-rm] = { |@args|
  ls $E:HOME/Library/Caches/JetBrains | from-lines
}

# Network
fn ntw-scan { nmap -sP 192.168.1.0/24 }

# Node.js
fn npm-up { npm-check-updates --deep -i }
fn node-clean {
  fd -HI --prune node_modules ^
    | from-lines ^
    | peach { |d| rm -rf $d }
}

# Packages
fn brew-dump { brew bundle dump --file $E:HOME/Projects/dots/brew/brewfile --force }
fn brew-up {
  brew update
  brew upgrade --fetch-HEAD --ignore-pinned
  brew cleanup
  brew doctor
}
fn pkg-su {
  put csharpier csharprepl dotnet-outdated-tool fantomas ^
    | each { |p| try { dotnet tool install -g $p } catch { } }

  npm install -g ^
    npm ^
    npm-check-updates
}
fn pkg-up {
  brew-up

  dotnet tool list -g ^
    | from-lines ^
    | drop 2 ^
    | each { |l| str:split ' ' $l | take 1 } ^
    | each { |p| dotnet tool update -g $p }

  npm-check-updates -g
}

# Python
fn py-a {
  if (not-eq $_paths $nil) {
    fail 'A venv is already active'
  }
  var venv = $pwd/venv/bin
  if (path:is-dir $venv | not (one)) {
    fail 'No venv found'
  }
  set _paths = $paths
  set paths = [$venv $@paths]
}
fn py-d {
  if (eq $_paths $nil) {
    fail 'No venv is active'
  }
  set paths = $_paths
  set _paths = $nil
}
fn py-su {
  python3 -m venv venv
  py-a
  pip install --upgrade pip
  pip install -r requirements.txt
}
fn py-up {
  py-a
  pip install --upgrade pip pur
  pur
  pip install -r requirements.txt
  py-d
}

# Shell
fn env-ls {
  env -0 ^
    | from-terminated "\x00" ^
    | each { |e| var k v = (str:split &max=2 = $e); put [$k $v] } ^
    | order
}
fn colortest { curl -s https://raw.githubusercontent.com/pablopunk/colortest/master/colortest | bash }
fn re { exec elvish }

# SSH
fn ssh-trust { |@a| ssh-copy-id -i $E:HOME/.ssh/id_rsa.pub $@a }

# VSCode
fn code-ext-dump { code --list-extensions > $E:HOME'/Library/Application Support/Code/User/extensions.txt' }
fn code-ext-install {
  from-lines < $E:HOME'/Library/Application Support/Code/User/extensions.txt' ^
    | each { |e| code --force --install-extension $e } [(all)]
}

# Web Browser
fn webbrowser { rm -fr $E:TMPDIR/webbrowser; '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --user-data-dir=$E:TMPDIR/webbrowser --disable-web-security --incognito --no-first-run --new-window http://localhost:4200 }

# Taken: a, b, f, e, i, n, p
set edit:insert:binding[Ctrl-d] = $edit:navigation:start~
set edit:insert:binding[Ctrl-l] = $edit:location:start~
set edit:insert:binding[Ctrl-o] = $edit:lastcmd:start~
set edit:insert:binding[Ctrl-r] = $edit:histlist:start~
set edit:insert:binding[Ctrl-t] = $cmd-edit~
set edit:insert:binding[Ctrl-y] = {
  fd -H --strip-cwd-prefix . ^
    | from-lines ^
    | each { |f| put [&to-accept=$f &to-filter=$f &to-show=$f] } ^
    | edit:listing:start-custom &caption='Files' &accept={ |f| edit:insert-at-dot $f } [(all)]
}
set edit:insert:binding[Ctrl-w] = $edit:kill-small-word-left~
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
