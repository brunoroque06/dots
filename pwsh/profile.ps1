$ErrorActionPreference = 'Stop'

$env:EDITOR = 'vim'
# $env:DOCKER_DEFAULT_PLATFORM = 'linux/amd64'
$env:VISUAL = $env:EDITOR
if ($IsMacOS) {
    $env:BAT_STYLE = 'plain'
    $env:BAT_THEME = 'ansi'
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
        "$HOME/.cargo/bin",
        '/usr/local/share/dotnet',
        "$HOME/.dotnet/tools",
        "$HOME/go/bin",
        "/Applications/Rider.app/Contents/MacOS"
    ) -join ':'
}

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
$inverse = "`e[7m"
$black = "`e[30m"
$red = "`e[31m"
$green = "`e[32m"
$yellow = "`e[33m"
$blue = "`e[34m"
$magenta = "`e[35m"
$white = "`e[37m"
$bgblack = "`e[40m"
$bgred = "`e[41m"
$bgblue = "`e[44m"
$default = "`e[0m"

$ps1 = "`e]133;A`a"
$ps0 = "`e]133;C`a"

function Get-PwdLeaf {
    if ($pwd.Path -eq $HOME) { return '~' }
    if ($pwd.Path -eq '/') { return $pwd.Path }
    return Split-Path -Leaf $pwd
}
function Set-TerminalDirectory {
    Write-Host -NoNewline ("`e]7;{0}`a" -f $pwd.Path)
}
function Set-TerminalTitle {
    Param(
        [Parameter(Mandatory)]
        [string]$Title
    )
    Write-Host -NoNewline "`e]0;$Title`a"
}
function Get-LastCommandDuration {
    $duration = (Get-History -Count 1).Duration
    if ($duration.TotalSeconds -lt 5) { return }
    if ($duration.TotalMinutes -lt 1) { return '{0:N0}s ' -f $duration.TotalSeconds }
    '{0:N0}m {1:N0}s ' -f $duration.TotalMinutes, $duration.Seconds
}

function Prompt {
    $last = Get-History -Count 1
    $exitCode = $last.ExecutionStatus -eq 'Failed' ? $bgred : $bgblue
    $dir = Get-PwdLeaf
    Set-TerminalDirectory
    Set-TerminalTitle $dir
    "$ps1$exitCode $default $blue$dir $yellow$(Get-LastCommandDuration)$magenta> $default"
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
    ListPredictionSelected = "$inverse"
    Member                 = "$blue"
    Number                 = "$magenta"
    Operator               = "$blue"
    Parameter              = "$black"
    Selection              = "$inverse"
    String                 = "$yellow"
    Type                   = "$blue"
    Variable               = "$green"
}

$PSStyle.FileInfo.Directory = "$black"
$PSStyle.FileInfo.SymbolicLink = "$blue"
$PSStyle.FileInfo.Executable = "$red"

Set-PSReadLineKeyHandler Enter -ScriptBlock {
    $cmd = $null; [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $cmd, [ref] $null)
    if ($cmd) { Set-TerminalTitle $cmd.Split()[0] }
    Write-Host -NoNewline $ps0
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

function Get-UniqueUnsorted {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$Objects
    )
    $set = New-Object System.Collections.Generic.HashSet[object]
    $res = New-Object System.Collections.Generic.List[object]
    foreach ($o in $Objects) {
        if ($set.Contains($o)) {
            continue
        }
        [void]$set.Add($o)
        $res.Add($o)
    }
    return $res
}

if ($IsMacOS) {
    carapace _carapace | Out-String | Invoke-Expression
}

# https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands
function Set-AliasByConvention {
    $verbs = @{}
    foreach ($v in Get-Verb) {
        $verbs[$v.Verb] = $v.AliasPrefix
    }
    $funcs = Get-ChildItem Function:
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

function Start-DotnetCsharp { csharprepl -t themes/VisualStudio_Light.json $args }
function Start-DotnetFsharp { dotnet fsi }
function Update-Dotnet { dotnet outdated --upgrade }
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    Param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        New-Object System.Management.Automation.CompletionResult $_
    }
}

function Copy-FileContent {
    Param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )
    Get-Content $File | Set-Clipboard
}
function Find-Directory {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    Get-ChildItem -Directory -Force -Recurse `
    | Where-Object Name -Match $Pattern `
    | Select-Object FullName
}
function Find-File {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    Get-ChildItem -Force -File -Recurse . `
    | Where-Object Name -Match $Pattern `
    | Select-Object FullName
}

function Format-D2 {
    Get-ChildItem -File `
    | Where-Object -Property Extension -EQ '.d2' `
    | ForEach-Object { d2 fmt $_.Name }
}
function Invoke-D2 {
    Get-ChildItem -File `
    | Where-Object -Property Extension -EQ '.d2' `
    | ForEach-Object { d2 --font-bold '/Users/brunoroque/Library/Fonts/CascadiaCode.ttf' --font-italic '/Users/brunoroque/Library/Fonts/CascadiaCodeItalic.ttf' --font-regular '/Users/brunoroque/Library/Fonts/CascadiaCode.ttf' --pad 0 $_.Name ('out/' + $_.BaseName + '.svg') }
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

function Update-Go { go get -u; go mod tidy }

function Remove-LoginItem {
    Param(
        [Parameter(Mandatory)]
        [string]$Dir
    )
    Remove-Item -Confirm -Force $Dir
}
Register-ArgumentCompleter -CommandName Remove-LoginItem -ParameterName Dir -ScriptBlock {
    $paths = @(
        "/Library/LaunchAgents",
        "/Library/LaunchDaemons",
        "~/Library/LaunchAgents"
    )
    $paths | ForEach-Object { Get-ChildItem $_ } | ForEach-Object {
        New-Object System.Management.Automation.CompletionResult $_.FullName
    }
}

function Remove-JetBrainsCache {
    Param(
        [Parameter(Mandatory)]
        [string]$Dir
    )
    foreach ($d in 'Application Support/JetBrains', 'Caches/JetBrains', 'Logs/JetBrains') {
        Remove-Item -Confirm -Force $(Join-Path $HOME 'Library' $d $Dir)
    }
}
Register-ArgumentCompleter -CommandName Remove-JetBrainsCache -ParameterName Dir -ScriptBlock {
    Get-ChildItem -Directory $HOME/Library/Caches/JetBrains | ForEach-Object {
        New-Object System.Management.Automation.CompletionResult $_.Name
    }
}

function Update-Npm { npm-check-updates --deep -i }

function Initialize-Packages {
    foreach ($p in 'csharpier', 'csharprepl', 'dotnet-outdated-tool', 'fantomas') {
        dotnet tool install -g $p
    }

    npm install -g `
        npm `
        npm-check-updates
}
function Update-Packages {
    # Update-Powershell
    Update-Brew
    dotnet tool list -g `
    | Select-Object -Skip 2 `
    | ForEach-Object { dotnet tool update -g $_.Split()[0] }
    npm-check-updates -g
}

function Format-PwshFile {
    Param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )
    $path = [System.IO.Path]::Combine($pwd, $File)
    $cnt = [System.IO.File]::ReadAllText($path);
    $fmted = Invoke-Formatter -ScriptDefinition $cnt;
    Set-Content $path $fmted -NoNewline;
}
function Initialize-Pwsh {
    # Install-Module CompletionPredictor
    Install-Module PSScriptAnalyzer
    Install-Module ZLocation
    Get-Module -l
}
function Restart-Pwsh { Switch-Process -WithCommand 'pwsh', '-WorkingDirectory', $pwd }
function Update-Pwsh { Update-Module -Force; Update-Help }

function Find-String {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    Get-ChildItem -File -Force -Recurse `
    | Select-String -Pattern $Pattern
}

function Initialize-Python {
    python3 -m venv .venv
    ./.venv/bin/Activate.ps1
    pip install --upgrade pip
    pip install -r requirements.txt
}
function Update-Python {
    ./.venv/bin/Activate.ps1
    pip install --upgrade pip pur
    Get-ChildItem `
    | Where-Object Name -Like 'requirements*.txt' `
    | ForEach-Object { pur -r $_; pip install -r $_ }
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

function Sync-ZLocation {
    (Get-ZLocation).Keys | ForEach-Object { if (!(Test-Path $_)) { Remove-ZLocation $_ } }
}

Set-Alias .. cd..
Set-Alias e vim
Set-Alias tf terraform

$kitten = '/Applications/kitty.app/Contents/MacOS/kitten'
Set-Alias kitten $kitten
function icat { & $kitten icat $args }

Set-AliasByConvention
