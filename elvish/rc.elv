use file
use math
use path
use platform
use re
use readline-binding
use str

if (eq $E:TERM xterm-ghostty) {
	try { use ghostty-integration } catch { printf 'Could not load ghostty integration' }
}

if (has-external coreutils) {
	coreutils --list ^
		| from-lines ^
		| drop 1 ^
		| each { |c| edit:add-var $c'~' { |@a| coreutils $c $@a } }
}

set paths = [
	/opt/homebrew/bin
	/opt/homebrew/opt/libpq/bin
	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
	$E:HOME/.cargo/bin
	/usr/local/share/dotnet
	$E:HOME/.dotnet/tools
	$E:HOME/.dotnet/tools/roslyn
	$E:HOME/go/bin
	/Applications/Rider.app/Contents/MacOS
]
var _paths = $nil

set-env BAT_STYLE plain
set-env BAT_THEME ansi
set-env D2_LAYOUT elk
# set-env DOCKER_DEFAULT_PLATFORM linux/amd64
set-env EDITOR /opt/homebrew/bin/nvim
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

# File System
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
fn icat { |@a| kitten icat $@a }
fn icat-watch { |i|
	while $true {
		clear
		kitten icat $i
		fswatch -1 $i
	}
}
set edit:completion:arg-completer[icat-watch] = { |@args| put *.png }
fn l { |@a| ls -Aho --color $@a }
fn t { |&l=2 @a| tree -L $l $@a }

# Applications
fn app-id { |a| mdls -name kMDItemCFBundleIdentifier /Applications/$a }
set edit:completion:arg-completer[app-id] = { |@args| ls /Applications | from-lines }

# Azure
fn az-act-set { |n| az account set -n $n }
set edit:completion:arg-completer[az-act-set] = { |@args|
	az account list ^
		| from-json ^
		| all (one) ^
		| each { |s| edit:complex-candidate $s[name] &display=(if (put $s[isDefault]) { styled $s[name] green } else { put $s[name] }) }
}

# Citrix
fn citrix-keyboard {
	var cfg = $E:HOME'/Library/Application Support/Citrix Receiver/Config'
	var us = (cat $cfg | slurp | re:replace 'KeyboardLayout=(.*)' KeyboardLayout=US (one))
	printf $us > $cfg
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
fn d2-ls { put *.d2 }
fn d2-fmt-all { d2-ls | each { |f| d2 fmt $f } }
fn d2-run-all { |&ext=svg| d2-ls | each { |f| d2 --pad 0 $f out/(file-stem $f).$ext } }
fn d2-icat-watch { |f|
	while $true {
		clear
		d2 $f --stdout-format png - | icat
		fswatch -1 $f
	}
}
set edit:completion:arg-completer[d2-watch] = { |@args| d2-ls }

# Dotnet
fn dot-ci { |@a| csharprepl -t themes/VisualStudio_Light.json $@a }
fn dot-fi { |@a| dotnet fsi $@a }
fn dot-roslyn {
	open https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.osx-arm64/versions

	var ver = (read-line)
	var zip = roslyn.zip
	var dir = roslyn
	var dest = $E:HOME/.dotnet/tools/roslyn

	cd $E:HOME/Downloads

	rm -rf $dir $zip
	curl -L 'https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/flat2/microsoft.codeanalysis.languageserver.osx-arm64/'$ver'/microsoft.codeanalysis.languageserver.osx-arm64.'$ver'.nupkg' -o $zip
	unzip $zip -d $dir

	rm -rf $zip $dest
	mv $dir/content/LanguageServer/osx-arm64 $dest
	rm -rf $dir

	chmod +x $dest/Microsoft.CodeAnalysis.LanguageServer
	codesign --force --sign - $dest/Microsoft.CodeAnalysis.LanguageServer
}
fn dot-up {
	dotnet list package --outdated --format json ^
		| from-json | put (one)[projects][0][frameworks][0][topLevelPackages] ^
		| each { |p| dotnet add package $p[id] --version $p[latestVersion] } (all)
}
set edit:completion:arg-completer[dotnet] = { |@args|
	dotnet complete (str:join ' ' $args) | from-lines
}

# Git
set edit:command-abbr['g'] = git
fn gi { gitu }

# Go
fn go-up { go get -u; go mod tidy }
set edit:completion:arg-completer[go] = { |@args|
	if (and (eq $args[1] test) (eq $args[2] -run)) {
		go test -list=. ^
			| from-lines ^
			| each { |l| if (str:has-prefix $l ok) { continue }; put $l }
	}
}

# JetBrains
fn jetbrains-rm { |a|
	var dirs = ['Application Support/JetBrains' Caches/JetBrains Logs/JetBrains]
	for d $dirs {
		rm -rf $E:HOME/Library/$d/$a
	}
}
set edit:completion:arg-completer[jetbrains-rm] = { |@args|
	put /Users/brunoroque/Library/Caches/JetBrains/* | each { |p| path:base $p }
}

# Json
fn json-fmt { |f|
	var cnt = (cat $f | jq -S | prettier --parser json | slurp)
	printf $cnt > $f
}

# Network
fn ntw-scan { nmap -sP 192.168.1.0/24 }

# Node.js
fn npm-clean {
	fd -HI --prune node_modules ^
		| from-lines ^
		| peach { |d| rm -rf $d }
}
fn npm-up { npm-check-updates --deep -i }

# Packages
fn brew-dump { brew bundle dump --file $E:HOME/Projects/dots/brew/brewfile --force }
fn brew-up {
	brew update
	brew upgrade
	brew autoremove
	brew cleanup
	brew doctor
}

fn pkg-su {
	put JetBrains.ReSharper.GlobalTools csharpier csharprepl fantomas ^
		| each { |p| try { dotnet tool install -g $p } catch { } }

	npm install -g @angular/language-server npm
}
fn pkg-up {
	try { brew-up } catch { }

	dotnet tool list --format json -g ^
		| from-json ^
		| all (one)[data] ^
		| each { |p| dotnet tool update -g $p[packageId] }

	npm-check-updates -g
}

# Podman
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

# Python
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
fn py-re-ls {
	put requirements*.txt
}
fn py-su {
	python3 -m venv .venv
	py-a
	pip install --upgrade pip
	py-re-ls | each { |r| pip install -r $r }
}
fn py-up {
	py-a
	pip install --upgrade pip pur
	py-re-ls | each { |r| pur -r $r; pip install -r $r }
	py-d
}
set edit:completion:arg-completer[pytest] = { |@args|
	pytest --collect-only -q ^
		| from-lines ^
		| each { |l| if (or (eq $l '') (str:contains $l 'tests collected in')) { continue }; put $l }
}

# Shell
fn env-ls {
	env -0 ^
		| from-terminated "\x00" ^
		| each { |e| var k v = (str:split &max=2 = $e); put [$k $v] } ^
		| order
}
fn colortest { curl -s https://raw.githubusercontent.com/pablopunk/colortest/master/colortest | zsh }
fn re { exec elvish }

# SSH
fn ssh-trust { |@a| ssh-copy-id -i $E:HOME/.ssh/id_rsa.pub $@a }

# Terraform
set edit:command-abbr['tf'] = terraform

# Typst
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

# VSCode
fn code-dump { code --list-extensions > $E:HOME'/Library/Application Support/Code/User/extensions.txt' }
fn code-su {
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
	fd -H -t file ^
		| from-lines ^
		| each { |f| put [&to-accept=$f &to-filter=$f &to-show=$f] } ^
		| edit:listing:start-custom &caption='Files' &accept={ |f| edit:insert-at-dot $f } [(all)]
}
set edit:insert:binding[Ctrl-w] = $edit:kill-small-word-left~
set edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
