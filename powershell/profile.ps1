$ErrorActionPreference = 'Stop'

$env:EDITOR = 'vim'
$Env:FZF_DEFAULT_OPTS = '--color bw --height ~40% --layout=default'
$env:VISUAL = $env:EDITOR

function Setup {
    # Import-Module CompletionPredictor
    # Install-Module Microsoft.PowerShell.ConsoleGuiTools
		If ($IsWindows) { go install github.com/junegunn/fzf@latest; fzf --version }
    Install-Module PSFzf
    Install-Module PSScriptAnalyzer
    Install-Module ZLocation
    Get-Module -l
}

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
    $path = if ($pwd.Path -eq $home) { '~' } else { Split-Path -Path $pwd -Leaf }
    $exitCode = if ($?) { $bgblue } else { $bgred }
    "$exitCode $default $blue$path $magenta~> $default"
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

function def {
    Param(
        [Parameter(Mandatory)]
        [string]$Cmd
    )
		(Get-Command $Cmd).Definition
}
function fd {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    git ls-files `
    | Get-ChildItem -Hidden `
    | where Name -Match $Pattern `
    | select FullName
}
function fmt {
    Param(
        [Parameter(Mandatory)]
        [IO.FileInfo]$File
    )
    $path = [System.IO.Path]::Combine($pwd, $File)
    $cnt = [IO.File]::ReadAllText($path);
    $fmted = Invoke-Formatter -ScriptDefinition $cnt;
    Set-Content $path $fmted -NoNewline;
}
function gid { git diff }
function gil {
    Param(
        [int]$Num = 10
    )
    git log --all --decorate --graph --format=format:'%Cblue%h %Creset- %Cgreen%ar %Creset%s %C(dim)- %an%C(auto)%d' -$Num
}
function gis { git status -s }
function re { Switch-Process pwsh }
function rg {
    Param(
        [Parameter(Mandatory)]
        [string]$Pattern
    )
    git ls-files `
    | Get-ChildItem -Hidden `
    | Select-String -Pattern $Pattern
}

Set-Alias .. cd..
Set-Alias e vim
Set-Alias l Get-ChildItem
Set-Alias rm Remove-Item
Set-Alias touch New-Item
Set-Alias which Get-Command

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

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
