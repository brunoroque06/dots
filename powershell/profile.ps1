$ErrorActionPreference = 'Stop'

$env:BAT_STYLE = 'plain'
$env:BAT_THEME = 'ansi'
$env:EDITOR = 'vim'
$env:FZF_DEFAULT_OPTS = '--color bw --height ~40% --layout=reverse'
$env:LESS = '-i --incsearch -m'
$env:PAGER = '/opt/homebrew/bin/less'
$env:RIPGREP_CONFIG_PATH = "$HOME/.config/ripgreprc"
$env:PATH = (
    '/opt/homebrew/bin',
    '/opt/homebrew/opt/libpq/bin',
    '/usr/local/bin',
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin',
    "$HOME/go/bin",
    '/usr/local/share/dotnet',
    "$HOME/.dotnet/tools"
) -join ':'
$env:VISUAL = $env:EDITOR

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
$esc = "`e"
$black = "$esc[30m"
$red = "$esc[31m"
$green = "$esc[32m"
$yellow = "$esc[33m"
$blue = "$esc[34m"
$magenta = "$esc[35m"
$white = "$esc[37m"
$bgblack = "$esc[40m"
$bgred = "$esc[41m"
$bgblue = "$esc[44m"
$default = "$esc[0m"

function Prompt {
    $dir = if ($pwd.Path -eq $HOME) { '~' } else { Split-Path -Path $pwd -Leaf }
    $exitCode = if ($?) { $bgblue } else { $bgred }
    "$exitCode $default $blue$dir $magenta~> $default"
}

$ReadLineOption = @{
    EditMode                      = 'Emacs'
    HistoryNoDuplicates           = $true
    HistorySearchCaseSensitive    = $false
    HistorySearchCursorMovesToEnd = $true
    PredictionSource              = 'None'
    PredictionViewStyle           = 'ListView'
}
Set-PSReadLineOption @ReadLineOption

Set-PSReadLineOption -Colors @{
    Command                = "$green"
    Comment                = "$yellow"
    Default                = "$black"
    Emphasis               = "$yellow"
    Error                  = "$red"
    Keyword                = "$blue"
    ListPrediction         = "$yellow"
    ListPredictionSelected = "$bgblack$white"
    Member                 = "$blue"
    Number                 = "$magenta"
    Operator               = "$blue"
    Parameter              = "$black"
    Selection              = "$bgblack$white"
    String                 = "$yellow"
    Type                   = "$blue"
    Variable               = "$green"
}

$PSStyle.FileInfo.Directory = "$black"
$PSStyle.FileInfo.SymbolicLink = "$blue"
$PSStyle.FileInfo.Executable = "$red"

# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Chord Ctrl+l -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('Invoke-FuzzyZLocation')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Chord Ctrl+t -Function ViEditVisually

# carapace _carapace | Out-String | Invoke-Expression

# https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands
function Set-AliasByConvention {
    $verbs = @{}
    foreach ($v in Get-Verb) {
        $verbs[$v.Verb] = $v.AliasPrefix
    }
    $funcs = Get-Command | Where-Object { -not $_.Source }
    foreach ($f in $funcs) {
        $v, $n = ($f.Name -split '-')[0, 1]
        if (-not $verbs.ContainsKey($v)) { continue }
        $a = ($n -creplace '[^A-Z]').ToLower()
        Set-Alias -Scope Global ($verbs[$v] + $a) $f.Name
    }
}

function Export-Brew {
    brew bundle dump --file $HOME/Projects/dots/brew/brewfile --force
}
function Update-Brew {
    brew update
    brew upgrade
    brew cleanup
    brew doctor
}

function Start-DotnetCsharp { csharprepl -t themes/VisualStudio_Light.json }
function Start-DotnetFsharp { dotnet fsi }
function Update-DotnetPackages { dotnet outdated --upgrade }
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    Param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_)
    }
}

function Copy-FileContent {
    Param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )
    Get-Content $File | Set-Clipboard
}
function Find-File {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    git ls-files `
    | Get-ChildItem -Hidden `
    | Where-Object Name -Match $Pattern `
    | Select-Object FullName
}

function Get-GitConfig { git config --list --show-origin }
function Get-GitDiff { git diff }
function Get-GitLog {
    Param(
        [int]$Num = 10
    )
    git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim)- %an%C(auto)%d' -$Num
}
function Get-GitStatus { git status -s }

function Remove-JetBrainsCache {
    Param(
        [Parameter(Mandatory)]
        [string]$Dir
    )
    foreach ($d in 'Application Support/JetBrains', 'Caches/JetBrains', 'Logs/JetBrains') {
        Remove-Item -Confirm $(Join-Path $HOME 'Library' $d $Dir)
    }
}
Register-ArgumentCompleter -CommandName Remove-JetBrainsCache -ParameterName Dir -ScriptBlock {
    Get-ChildItem -Directory $HOME/Library/Caches/JetBrains | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.Name)
    }
}

function Update-Npm { npm-check-updates --deep -i }

function Initialize-Packages {
    foreach ($p in 'csharprepl', 'dotnet-outdated-tool', 'fantomas-tool') {
        dotnet tool install -g $p
    }

    npm install -g `
        npm `
        npm-check-updates `
        paperspace-node
}
function Update-Packages {
    Update-Powershell
    Update-Brew
    dotnet tool list -g `
    | Select-Object -Skip 2 `
    | ForEach-Object { dotnet tool update -g $_.Split()[0] }
    npm-check-updates -g
}

function Format-PowershellFile {
    Param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )
    $path = [System.IO.Path]::Combine($pwd, $File)
    $cnt = [System.IO.File]::ReadAllText($path);
    $fmted = Invoke-Formatter -ScriptDefinition $cnt;
    Set-Content $path $fmted -NoNewline;
}
function Initialize-Powershell {
    # Install-Module CompletionPredictor
    if ($IsWindows) { go install github.com/junegunn/fzf@latest; fzf --version }
    Install-Module PSFzf
    Install-Module PSScriptAnalyzer
    Install-Module ZLocation
    Get-Module -l
}
function Restart-Powershell { Switch-Process pwsh }
function Update-Powershell { Update-Module; Update-Help }

function Find-String {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    git ls-files `
    | Get-ChildItem -Hidden `
    | Select-String -Pattern $Pattern
}

function Initialize-Python {
    python3 -m venv venv
    ./venv/bin/Activate.ps1
    pip install --upgrade pip
    pip install -r requirements.txt
}
function Update-Python {
    ./venv/bin/Activate.ps1
    pip install --upgrade pip pur
    pur
    pip install -r requirements.txt
    deactivate
}

function Export-VSCode { code --list-extensions > "$HOME/Projects/dots/vscode/extensions.txt" }
function Initialize-VSCode {
    Get-Content "$HOME/Projects/dots/vscode/extensions.txt" `
    | ForEach-Object { code --force --install-extension $_ }
}

function Start-WebBrowser {
    Remove-Item -Recurse $env:TMPDIR/webbrowser
    & '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' `
        --disable-web-security `
        --incognito `
        --new-window http://localhost:4200 `
        --no-first-run `
        --user-data-dir=$env:TMPDIR/webbrowser
}

Set-Alias .. cd..
Set-Alias e vim
Set-AliasByConvention
