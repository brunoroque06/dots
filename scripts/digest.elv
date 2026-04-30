# set-env COPILOT_GITHUB_TOKEN ...

use os
use path
use re
use str

var last = 5
var retry = 3

fn temp-file { |n|
  os:temp-file $n | put (one)[name]
}

fn get { |url|
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    --fail ^
    --retry $retry ^
    -s
}

fn get-comp { |url|
  var f = (temp-file index.html)
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    -H 'Accept-Language: en-US,en;q=0.9' ^
    -H 'Priority: u=0, i' ^
    --compressed ^
    --fail ^
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
    re:find '(?s)<item>.*?<title>(.*?)</title>.*?</item>' $html ^
      | each { |i| put $i[groups][1][text] }
  )
  var @links = (
    re:find '(?s)<item>.*?<link>(.*?)</link>.*?</item>' $html ^
      | each { |i| put $i[groups][1][text] }
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
    re:find '(?s)<a[^>]*href[^>]*>.*?</a>' (cat $f | slurp) ^
      | each { |i| put $i[groups][0][text] }
  )
  each { |i| echo $i } $titles > $f
  try {
    /opt/homebrew/bin/copilot --add-dir (path:dir $f) -p 'Read '$f', output json array with title and url for the '$last' most important news' -s ^
      | slurp ^
      | re:find '(?s)```json(.*)```' (one) ^
      | printf (one)[groups][1][text] ^
      | from-json
  } catch _ {
    put []
  }
}

fn report { |title items|
  printf $title"\n\n"
  fn clean-url { |u| str:split '?' $u | take 1 }
  each { |a| printf $a[title]' '(clean-url $a[url])"\n" } $items
  printf "\n"
}

