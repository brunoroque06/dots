function TypeKeys {
    param (
        [string]$Text,
        [bool]$Esc = $false,
        [bool]$Enter = $false
    )
    $cmd = @('tell application "System Events"')
    if ($Esc) {
        $cmd += '  key code 53'
        $cmd += '  delay 0.5'
    }
    $cmd += "  keystroke `"$Text`""
    if ($Enter) {
        $cmd += '  key code 36'
    }
    $cmd += 'end tell'
    $as = $cmd -join "`n"
    $sh = "osascript -e '$as'"
    Invoke-Expression $sh
}
