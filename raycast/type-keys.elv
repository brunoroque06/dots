use str

var header = 'tell application "System Events"'
var escKey = (if $args[1] { put ['  key code 53' '  delay 0.5'] } else { put [] })
var keys = '  keystroke "'$args[0]'"'
var enterKey = (if $args[2] { put ['  key code 36'] } else { put [] })
var end = 'end tell'

var cmd = (str:join "\n" [$header $@escKey $keys $@enterKey $end])

# print $cmd
osascript -e $cmd
