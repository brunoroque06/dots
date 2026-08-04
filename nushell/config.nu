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
$env.EDITOR = 'hx'
$env.LESS = '-i --incsearch -m'
$env.LS_COLORS = 'di=34:fi=30:ex=31:ln=30'
$env.PAGER = '/opt/homebrew/bin/less'
$env.RIPGREP_CONFIG_PATH = ($env.HOME)/.config/ripgreprc
$env.VISUAL = $env.EDITOR

let col_acc = 'magenta'
let col_err = 'red'
let col_pri = 'blue'
let col_sel = $'($col_acc)_reverse'

$env.PROMPT_COMMAND = {||
    let status = if $env.LAST_EXIT_CODE == 0 { $col_pri } else { $col_err }
    let venv = if 'PATH_BCK' in $env { ' *' } else { '' }
    let dir = match $env.PWD {
        $pwd if $pwd == $nu.home-dir => '~'
        $pwd => ($pwd | path basename)
    }
    $'(ansi $'($status)_reverse') (ansi reset)($venv)(ansi $col_pri) ($dir)(ansi reset) '
}
$env.PROMPT_COMMAND_RIGHT = ''
$env.PROMPT_INDICATOR = $'(ansi $col_acc)>(ansi reset) '

$env.config = {
    abbreviations: {e: $env.EDITOR, gi: 'gitu', l: 'ls'}
    color_config: {
        search_result: $col_sel
        shape_custom: green
        shape_directory: default
        shape_external: green
        shape_externalarg: default
        shape_filepath: default
        shape_flag: default
        shape_int: default
        shape_internalcall: green
        shape_string: default
    }
    completions: {algorithm: fuzzy}
    history: {file_format: 'sqlite', isolation: true}
    show_banner: false
    show_hints: false
    table: {index_mode: 'auto', mode: 'none'}
}

let style = {
    description_text: default
    match_text: {attr: u}
    selected_match_text: {attr: ur}
    selected_text: $col_sel
    text: default
}

$env.config.menus ++= [
    {
        marker: $'(ansi $col_acc)| '
        name: completion_menu
        only_buffer_difference: false
        style: $style
        type: {layout: columnar}
    }
    {
        marker: $'(ansi $col_acc)| '
        name: ide_completion_menu
        only_buffer_difference: false
        style: $style
        type: {layout: ide}
    }
    {
        marker: $'(ansi $col_acc)? '
        name: help_menu
        only_buffer_difference: true
        style: $style
        type: {layout: description}
    }
    {
        marker: $'(ansi $col_acc)? '
        name: history_menu
        only_buffer_difference: true
        style: $style
        type: {layout: list}
    }
]

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
def input-fuzzy [t: string] { input list --fuzzy --no-separator --no-footer $'(ansi $col_acc)($t)(ansi reset)' }
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

# macOS
def app-files [] {
    glob '/System/Applications/*.app' | append (glob '/Applications/*.app')
}
def app-id [app: path@"app-files"] {
    ^mdls -name kMDItemCFBundleIdentifier $app
}

# packages
def pkg-su [] {
    for p in [csharpier csharprepl fantomas roslyn-language-server] {
        ^dotnet tool install --global $p
    }
    ^npm install --global @angular/language-server npm
}
def pkg-up [] {
    try {
        brew upgrade
        brew autoremove
        brew cleanup
        brew doctor
    }

    for p in (^dotnet tool list --format json --global | from json | get data) {
        ^dotnet tool update --global --prerelease $p.packageId
    }

    ^npm-check-updates --global
}

# python
def --env py-a [] {
    if 'PATH_BCK' in $env {
        error make {msg: 'venv is already active'}
    }
    let venv = $env.PWD | path join .venv bin
    if ($venv | path type) != dir {
        error make {msg: 'No venv found'}
    }
    $env.PATH_BCK = $env.PATH
    $env.PATH = ($env.PATH | prepend $venv)
    $env.PYTHONPATH = $env.PWD
}
def --env py-d [] {
    if 'PATH_BCK' not-in $env {
        error make {msg: 'No venv is active'}
    }
    $env.PATH = $env.PATH_BCK
    hide-env PATH_BCK
    hide-env PYTHONPATH
}
def --env py-su [] {
    python3 -m venv .venv
    py-a
    pip install --upgrade pip
    pip install .
}

# terminal
def colors [] {
    [
        black
        red
        green
        yellow
        blue
        magenta
        cyan
        white
        dark_gray
        light_red
        light_green
        light_yellow
        light_blue
        light_magenta
        light_cyan
        light_gray
    ]
    | each {|c|
      let label = $c | fill --width 14
      $'(ansi { fg: $c attr: r })  (ansi reset) (ansi $c)($label)(ansi reset)'
    }
    | chunks 8
    | each {|r| $r | str join '' }
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
        mode: [emacs]
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
