# set-env COPILOT_GITHUB_TOKEN ...

use os
use path
use re

var last = 5
var retry = 3
var news = []

fn append { |title items|
  set news = [$@news [&title=$title &news=$items]]
}

fn get { |url|
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    --retry $retry ^
    -s
}

fn temp-file { |n|
  os:temp-file $n | put (one)[name]
}

fn get-comp { |url|
  var f = (temp-file index.html)
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    -H 'Accept-Language: en-US,en;q=0.9' ^
    -H 'Priority: u=0, i' ^
    --compressed ^
    --output $f ^
    --retry $retry ^
    -s
  defer { rm $f }
  cat $f
}

fn reddit { |sub|
  get 'https://www.reddit.com/r/'$sub'/hot.json?limit='$last ^
    | from-json ^
    | put (one)[data][children] ^
    | all (one) ^
    | each { |e| put [&title=$e[data][title] &url='https://www.reddit.com'$e[data][permalink]] } ^
    | put [(all)]
}

fn rss { |url|
  var html = (get $url | slurp)
  var @titles = (
    re:find '(?s)<item>(.*?)<title>(.*?)</title>(.*?)</item>' $html ^
      | each { |i| put $i[groups][2][text] }
  )
  var @links = (
    re:find '(?s)<item>(.*?)<link>(.*?)</link>(.*?)</item>' $html ^
      | each { |i| put $i[groups][2][text] }
  )
  each { |i| put [&title=$titles[$i] &url=$links[$i]] } [(range (count $titles))] ^
    | take $last ^
    | put [(all)]
}

fn digest { |url &comp=$false|
  var html = (if (put $comp) { get-comp $url } else { get $url } | slurp)
  var f = (temp-file index.html)
  printf $html > $f
  defer { rm $f }
  var @titles = (
    re:find '(?s)<a(.*?)</a>' (cat $f | slurp) ^
      | each { |i| put $i[groups][0][text] }
  )
  each { |i| echo $i } $titles > $f
  /opt/homebrew/bin/copilot --add-dir (path:dir $f) -p 'Output json. Read '$f', output title and url for the '$last' most important news' -s ^
    | slurp ^
    | re:find '(?s)```json(.*)```' (one) ^
    | printf (one)[groups][1][text] ^
    | from-json
}

each { |n|
  printf $n[title]"\n\n"
  each { |a| printf $a[title]' '$a[url]"\n" } $n[news]
  printf "\n"
} $news
