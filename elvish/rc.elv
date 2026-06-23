use file
use math
use os
use path
use platform
use re
use readline-binding
use str

if (eq $E:TERM xterm-ghostty) {
	use ghostty-integration
}

if (has-external coreutils) {
	coreutils --list ^
		| from-lines ^
		| drop 1 ^
		| each { |c| edit:add-var $c'~' { |@a| coreutils $c $@a } }
}

set paths = [
	/opt/homebrew/bin
	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
	$E:HOME/.dotnet/tools
]
var _paths = $nil

set-env BAT_STYLE plain
set-env BAT_THEME ansi
set-env EDITOR /opt/homebrew/bin/hx
set-env LESS '-i --incsearch -m'
set-env PAGER /opt/homebrew/bin/less
# set-env REQUESTS_CA_BUNDLE $E:HOME/.proxyman/proxyman-ca.pem # proxyman with python
set-env RIPGREP_CONFIG_PATH $E:HOME/.config/ripgreprc
set-env VISUAL $E:EDITOR

fn path { tilde-abbr $pwd | path:base (one) }

var _dur = 0
var _err = $false

set edit:after-command = [
	{ |m| set _dur = $m[duration] }
	{ |m| set _err = (not-eq $m[error] $nil) }
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

	styled ' > ' magenta
}
set edit:rprompt = (constantly (whoami)@(hostname))

eval (carapace _carapace | slurp)

# file system
fn .. { cd .. }
fn c { |f|
	if (str:has-suffix $f .md) {
		glow $f
	} else {
		bat $f
	}
}
fn dir-size { dust -d 1 }
fn e { |@a| $E:EDITOR $@a }
fn fd { |@a| e:fd -c never $@a }
fn file-stem { |f| str:trim-suffix $f (path:ext $f) }
fn file-yank { |f| pbcopy < $f }
set edit:completion:arg-completer[file-yank] = { |@args|
	fd -H -t file | from-lines
}
fn l { |@a| ls -Aho --color $@a }
fn t { |&l=2 @a| tree -L $l $@a }

# ai
fn ai-review { |&src=main &tgt=HEAD|
	var diff = diff.txt
	git diff --histogram $src...$tgt > $diff
	defer { rm $diff }
	copilot -p 'Review the PR changes on '$diff'. Search for bugs, regressions, inconsistencies'
}

# azure
fn az-act-set { |n| az account set -n $n }
set edit:completion:arg-completer[az-act-set] = { |@args|
	az account list ^
		| from-json ^
		| all (one) ^
		| each { |s| edit:complex-candidate $s[name] &display=(if (put $s[isDefault]) { styled $s[name] green } else { put $s[name] }) }
}

# command
fn cmd-edit {
	var tmp = (os:temp-file elvcmd)
	print $edit:current-command > $tmp
	try {
		$E:EDITOR $tmp[name] <$os:dev-tty >$os:dev-tty 2>&1
		set edit:current-command = (slurp < $tmp[name] | str:trim-right (one) "\n")
	} finally {
		file:close $tmp
		rm $tmp[name]
	}
}

# d2
fn d2-ls { put *.d2 }
fn d2-fmt-all { d2-ls | each { |f| d2 fmt $f } }
fn d2-run-all { |&ext=svg| d2-ls | each { |f| d2 --pad 0 $f out/(file-stem $f).$ext } }
fn d2-watch { |f|
	while $true {
		clear
		d2 $f --stdout-format txt - | cat
		fswatch -1 $f
	}
}
set edit:completion:arg-completer[d2-watch] = { |@args| d2-ls }

# dotnet
fn dot-ci { |@a| csharprepl -t themes/VisualStudio_Light.json $@a }
fn dot-fi { |@a| dotnet fsi $@a }
fn dot-up {
	dotnet list package --outdated --format json ^
		| from-json | put (one)[projects][0][frameworks][0][topLevelPackages] ^
		| each { |p| dotnet add package $p[id] --version $p[latestVersion] } (all)
}
set edit:completion:arg-completer[dotnet] = { |@args|
	dotnet complete (str:join ' ' $args) | from-lines
}

# git
set edit:command-abbr['g'] = git
fn gi { gitu }
fn gi-fp { |b| git fetch origin $b:$b }

# go
fn go-up { go get -u; go mod tidy }
set edit:completion:arg-completer[go] = { |@args|
	if (and (eq $args[1] test) (eq $args[2] -run)) {
		go test -list=. ^
			| from-lines ^
			| each { |l| if (str:has-prefix $l ok) { continue }; put $l }
	}
}

# macOS
fn app-id { |a| mdls -name kMDItemCFBundleIdentifier $a }
set edit:completion:arg-completer[app-id] = { |@args| put /System/Applications/*.app /Applications/*.app }

var defaults-dir = $E:HOME'/Library/Mobile Documents/com~apple~CloudDocs/defaults'
var defaults-suffix = .plist
fn defaults-export {
	rm -rf $defaults-dir
	mkdir $defaults-dir
	fn exp { |d| defaults export $d $defaults-dir/$d$defaults-suffix }
	exp NSGlobalDomain
	defaults domains ^
	  | slurp ^
		| str:split ', ' (one) ^
	  | peach { |d| if (str:has-prefix $d com.apple) { exp $d } }
}
fn defaults-import {
	ls $defaults-dir ^
	  | from-lines ^
	  | each { |f| defaults import (str:trim-suffix $f $defaults-suffix) $defaults-dir/$f }
}

# network
fn ntw-scan { nmap -sP 192.168.1.0/24 }

# node.js
fn npm-up { npm-check-updates --deep -i }

# packages
fn brew-dump { brew bundle dump --file $E:HOME/Projects/dots/brew/brewfile --force }
fn brew-up {
	brew update
	brew upgrade
	brew autoremove
	brew cleanup
	brew doctor
}

fn pkg-su {
	put csharpier csharprepl fantomas roslyn-language-server ^
		| each { |p| try { dotnet tool install -g $p } catch { } }

	npm install -g @angular/language-server npm
}
fn pkg-up {
	try { brew-up } catch { }

	dotnet tool list --format json -g ^
		| from-json ^
		| all (one)[data] ^
		| each { |p| dotnet tool update -g --prerelease $p[packageId] }

	npm-check-updates -g
}

# podman
fn pod-clean {
	podman system prune -af
}
fn pod-cnt-rm {
	podman stop (podman ps -aq); podman rm (podman ps -aq)
}
fn pod-exec { |cnt| podman exec -it $cnt bash }
set edit:completion:arg-completer[pod-exec] = { |@args|
	podman ps --format '{{.Image}} {{.Names}}' ^
		| from-lines ^
		| each { |cnt| var c = (str:split ' ' $cnt | put [(all)]); put [&img=$c[0] &name=$c[1]] } ^
		| each { |cnt| edit:complex-candidate &display=$cnt[name]' ('$cnt[img]')' $cnt[name] }
}

# python
fn py-a {
	if (not-eq $_paths $nil) {
		fail 'A venv is already active'
	}
	var venv = $pwd/.venv/bin
	if (path:is-dir $venv | not (one)) {
		fail 'No venv found'
	}
	set _paths = $paths
	set paths = [$venv $@paths]
	set-env PYTHONPATH (pwd)
}
fn py-d {
	if (eq $_paths $nil) {
		fail 'No venv is active'
	}
	set paths = $_paths
	set _paths = $nil
	unset-env PYTHONPATH
}
fn py-su {
	python3 -m venv .venv
	py-a
	pip install --upgrade pip
	pip install .
}
set edit:completion:arg-completer[pytest] = { |@args|
	pytest --collect-only -q ^
		| from-lines ^
		| each { |l| if (or (eq $l '') (str:contains $l 'tests collected in')) { continue }; put $l }
}

# shell
fn env-ls {
	env -0 ^
		| from-terminated "\x00" ^
		| each { |e| var k v = (str:split &max=2 = $e); put [$k $v] } ^
		| order
}
fn colortest { curl -s https://raw.githubusercontent.com/pablopunk/colortest/master/colortest | zsh }
fn re { exec elvish }

# ssh
fn ssh-trust { |@a| ssh-copy-id -i $E:HOME/.ssh/id_rsa.pub $@a }

# typst
fn typst-to-pptx { |f|
	var stem = (file-stem $f)
	var out = out/$stem
	var ppi = 512
	mkdir -p $out
	defer { rm -rf $out }
	typst compile --ppi $ppi $f $out'/page-{0p}.png'
	cd $out
	var md = (put *.png | each { |p| put '# {background-image="'$p'"}' } | str:join "\n\n---\n\n" [(all)])
	printf $md > main.md
	pandoc --dpi $ppi main.md -o ../../$stem.pptx
	cd ../..
}
set edit:completion:arg-completer[typst-to-pptx] = { |@args| put *.typ }

# vscode
fn code-dump { code --list-extensions > $E:HOME'/Library/Application Support/Code/User/extensions.txt' }
fn code-su {
	from-lines < $E:HOME'/Library/Application Support/Code/User/extensions.txt' ^
		| each { |e| code --force --install-extension $e } [(all)]
}
fn code-key-win { cat $E:HOME/Projects/dots/vscode/keybindings.json | slurp | str:replace 'cmd' 'ctrl' (one) | printf (one) | pbcopy }

# web browser
fn webbrowser { rm -fr $E:TMPDIR/webbrowser; '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --user-data-dir=$E:TMPDIR/webbrowser --disable-web-security --incognito --no-first-run --new-window http://localhost:4200 }

# Taken: a, b, f, e, i, n, p
set edit:insert:binding[Ctrl-d] = $edit:navigation:start~
set edit:insert:binding[Ctrl-l] = $edit:location:start~
set edit:insert:binding[Ctrl-o] = $edit:lastcmd:start~
set edit:insert:binding[Ctrl-r] = $edit:histlist:start~
set edit:insert:binding[Ctrl-t] = $cmd-edit~
set edit:insert:binding[Ctrl-y] = {
	fd -H -t file ^
		| from-lines ^
		| each { |f| put [&to-accept=$f &to-filter=$f &to-show=$f] } ^
		| edit:listing:start-custom &caption='Files' &accept={ |f| edit:insert-at-dot $f } [(all)]
}
set edit:insert:binding[Ctrl-w] = $edit:kill-small-word-left~
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
