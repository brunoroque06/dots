$env.PATH = [
    /opt/homebrew/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    ($env.HOME)/.cargo/bin
    ($env.HOME)/.dotnet/tools
]

$env.BAT_STYLE = 'plain'
$env.BAT_THEME = 'ansi'
$env.CARAPACE_COLOR = 0
$env.EDITOR = '/opt/homebrew/bin/hx'
$env.LESS = '-i --incsearch -m'
$env.LS_COLORS = (vivid generate ansi)
$env.PAGER = '/opt/homebrew/bin/less'
$env.RIPGREP_CONFIG_PATH = ($env.HOME)/.config/ripgreprc
$env.VISUAL = $env.EDITOR

$env.PROMPT_COMMAND = {||
    let status_color = if $env.LAST_EXIT_CODE == 0 { 'blue' } else { 'red' }
    let dir = match $env.PWD {
        $pwd if $pwd == $nu.home-dir => '~'
        $pwd => ($pwd | path basename)
    }
    $'(ansi { fg: $status_color attr: r }) (ansi reset)(ansi blue) ($dir)(ansi reset) '
}
$env.PROMPT_COMMAND_RIGHT = ''

$env.config = {
    history: {file_format: 'sqlite'}
    show_banner: false
    show_hints: false
    table: {index_mode: 'auto', mode: 'none'}
}

$env.config.abbreviations = {
    gi: 'gitu'
    l: 'ls'
}

# ai
def ai-review [src: string = 'main', tgt: string = 'HEAD'] {
    let diff = 'diff.txt'
    try {
        ^git diff --histogram $'($src)...($tgt)' | save --raw $diff
        ^copilot -p $'Review the PR changes in ($diff). Search for bugs, regressions, and inconsistencies.'
    } finally {
        rm $diff
    }
}

# autocomplete
def carapace-su [] {
    mkdir $nu.cache-dir
    carapace _carapace nushell | save --force ($nu.cache-dir)/carapace.nu
}

# command
def cmd-edit [] {
    let tmp = mktemp --suffix '.nu'
    try {
        commandline | save --force --raw $tmp
        ^$env.EDITOR $tmp
        let edited = open --raw $tmp | str trim --right --char "\n"
        commandline edit --replace $edited
    } finally {
        rm $tmp
    }
}
def input-fuzzy [t: string] { input list --fuzzy --no-separator --no-footer $'(ansi blue)($t)(ansi reset)' }
def cmd-last-insert [] {
    let el = (
    history
      | last
      | get command
      | split row ' '
      | input-fuzzy 'Last Command'
  )
    if $el != null { commandline edit --insert $el }
}

# docs
def typst-files [] {
    glob '*.typ'
}
def typst-to-pptx [f: path@"typst-files"] {
    let stem = $f | path parse | get stem
    let out = ($env.PWD)/out/($stem)
    let ppi = 512
    mkdir $out
    try {
        ^typst compile --ppi $ppi $f ($out)/'page-{0p}.png'
        let md = (
      glob $'($out)/*.png'
        | sort
        | each { |page|
          let name = $page | path basename
          $'# {background-image="($name)"}'
        }
        | str join "\n\n---\n\n"
    )
        $md | save ($out)/main.md
        ^pandoc --dpi $ppi ($out)/main.md -o ($env.PWD)/($stem).pptx
    } finally {
        rm --recursive $out
    }
}

# diagram
def d2-files [] {
    glob '*.d2'
}
def d2-icat [f: path@"d2-files"] {
    ^d2 $f --stdout-format png - | ^viu -
}
def d2-watch [f: path@"d2-files"] {
    clear
    d2-icat $f

    for ev in (watch $f) {
        if $ev.operation == 'Create' {
            clear
            d2-icat $f
        }
    }
}

# file system
def c [f: path] {
    if ($f | str ends-with '.md') {
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
      | input-fuzzy 'Directory'
  )
    if $dir != null { cd $dir }
}
def e [...args] {
    ^$env.EDITOR ...$args
}

# macOS
def app-files [] {
    glob '/System/Applications/*.app' | append (glob '/Applications/*.app')
}
def app-id [app: path@"app-files"] {
    ^mdls -name kMDItemCFBundleIdentifier $app
}

# packages
def pkg-su [] {
    [csharpier csharprepl fantomas roslyn-language-server]
    | each {|p| ^dotnet tool install --global $p }
    ^npm install --global @angular/language-server npm
}
def pkg-up [] {
    try {
        brew upgrade
        brew autoremove
        brew cleanup
        brew doctor
    }

    ^dotnet tool list --format json --global
    | from json
    | get data
    | each {|p| ^dotnet tool update --global --prerelease $p.packageId }

    ^npm-check-updates --global
}

$env.config.keybindings ++= [
    {
        name: help_menu
        modifier: control
        keycode: char_h
        mode: [emacs]
        event: {send: menu, name: help_menu}
    }
    {
        name: ide_completion_menu
        modifier: control
        keycode: char_j
        mode: [emacs vi_insert vi_normal]
        event: {send: menu, name: ide_completion_menu}
    }
    {
        name: dir_history
        modifier: control
        keycode: char_l
        mode: [emacs]
        event: {send: executehostcommand, cmd: 'cd-history'}
    }
    {
        name: last_cmd_el
        modifier: control
        keycode: char_o
        mode: [emacs]
        event: {send: executehostcommand, cmd: 'cmd-last-insert'}
    }
    {
        name: cmd_edit
        modifier: control
        keycode: char_t
        mode: [emacs]
        event: {send: executehostcommand, cmd: 'cmd-edit'}
    }
]

source ($nu.cache-dir)/carapace.nu
