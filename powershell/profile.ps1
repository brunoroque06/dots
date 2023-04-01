$ErrorActionPreference = 'Stop'

# Import-Module CompletionPredictor
Import-Module PSScriptAnalyzer
Import-Module ZLocation

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

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

function Fmt {
    Param(
        [Parameter(Mandatory)]
        [IO.FileInfo]$file
    )
    $cnt = [IO.File]::ReadAllText($file.FullName);
    $fmted = Invoke-Formatter -ScriptDefinition $cnt;
    Set-Content $file.FullName $fmted -NoNewline;
}

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

function Re { Switch-Process pwsh }
function gd { git diff }
function gs { git status -s }

Set-Alias .. cd..
Set-Alias e vim
Set-Alias l Get-ChildItem
Set-Alias touch New-Item

carapace _carapace | Out-String | Invoke-Expression

