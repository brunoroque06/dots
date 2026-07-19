# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
$env.PATH = [
  /opt/homebrew/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  ($env.HOME | path join ".cargo" "bin")
  ($env.HOME | path join ".dotnet" "tools")
]

$env.BAT_STYLE = "plain"
$env.BAT_THEME = "ansi"
$env.EDITOR = "/opt/homebrew/bin/hx"
$env.LESS = "-i --incsearch -m"
$env.LS_COLORS = (vivid generate one-light)
$env.PAGER = "/opt/homebrew/bin/less"
$env.RIPGREP_CONFIG_PATH = ($env.HOME | path join ".config" "ripgreprc")
$env.VISUAL = $env.EDITOR

$env.PROMPT_COMMAND = {||
  let status_color = if $env.LAST_EXIT_CODE == 0 { "blue" } else { "red" }
  let directory = if $env.PWD == $env.HOME {
    "~"
  } else {
    $env.PWD | path basename
  }
  $"(ansi { fg: $status_color attr: r }) (ansi reset)(ansi blue) ($directory)(ansi reset) "
}

$env.config = {
  history: {
    file_format: "sqlite"
  }
  show_banner: false
  show_hints: false
  table: {
    mode: "none"
  }
}

# ai
def ai-review [
  --src: string = "main"
  --tgt: string = "HEAD"
] {
  let diff = "diff.txt"
  try {
    ^git diff --histogram $"($src)...($tgt)" | save --raw $diff
    ^copilot -p $"Review the PR changes in ($diff). Search for bugs, regressions, and inconsistencies."
  } finally {
    rm $diff
  }
}

# command
def cmd-edit [] {
  let tmp = mktemp --suffix ".nu"
  try {
    commandline | save --force --raw $tmp
    ^$env.EDITOR $tmp
    let edited = open --raw $tmp | str trim --right --char "\n"
    commandline edit --replace $edited
  } finally {
    rm $tmp
  }
}
def cmd-last-insert [] {
  let el = (
    history
      | last
      | get command
      | split words
      | input list --fuzzy "Last command"
  )
  if $el != null { commandline edit --insert $el }
}

# docs
def typst-files [] {
  glob "*.typ"
}
def typst-to-pptx [f: path@typst-files] {
  let stem = $f | path parse | get stem
  let out = $env.PWD | path join "out" $stem
  let ppi = 512
  mkdir $out
  try {
    ^typst compile --ppi $ppi $f ($out | path join "page-{0p}.png")
    let md = (
      glob $"($out)/*.png"
        | sort
        | each { |page|
          let name = $page | path basename
          $"# {background-image=\"($name)\"}"
        }
        | str join "\n\n---\n\n"
    )
    $md | save ($out | path join "main.md")
    ^pandoc --dpi $ppi ($out | path join "main.md") -o ($env.PWD | path join $"($stem).pptx")
  } finally {
    rm --recursive $out
  }
}

# diagram
def d2-files [] {
  glob "*.d2"
}
def d2-watch [f: path@d2-files] {
  while true {
    clear
    ^d2 $f --stdout-format png | ^viu -
    ^fswatch -1 $f | ignore
  }
}

# file system
alias l = ls
def c [f: path] {
  if ($f | str ends-with ".md") {
    ^glow $f
  } else {
    ^bat $f
  }
}
def --env cd-history [] {
  let dir = (
    history
      | get cwd
      | reverse
      | uniq
      | input list --fuzzy "Directory"
  )
  if $dir != null { cd $dir }
}
def e [...args] {
  ^$env.EDITOR ...$args
}

# macOS
def app-files [] {
  glob "/System/Applications/*.app" | append (glob "/Applications/*.app")
}
def app-id [app: path@app-files] {
  ^mdls -name kMDItemCFBundleIdentifier $app
}

# packages
def pkg-su [] {
  [csharpier csharprepl fantomas roslyn-language-server]
    | each { |p| ^dotnet tool install --global $p }
  ^npm install --global @angular/language-server npm
}
def pkg-up [] {
	brew upgrade
	brew autoremove
	brew cleanup
	brew doctor

  ^dotnet tool list --format json --global
    | from json
    | get data
    | each { |t| ^dotnet tool update --global --prerelease $t.packageId }

  ^npm-check-updates --global
}

$env.config.keybindings ++= [
  {
    name: dir_history
    modifier: control
    keycode: char_l
    mode: [emacs vi_insert]
    event: { send: executehostcommand cmd: "cd-history" }
  },
  {
    name: last_cmd_el
    modifier: control
    keycode: char_o
    mode: [emacs vi_insert]
    event: { send: executehostcommand cmd: "cmd-last-insert" }
  }
  {
    name: cmd_edit
    modifier: control
    keycode: char_t
    mode: [emacs vi_insert]
    event: { send: executehostcommand cmd: "cmd-edit" }
  }
]
