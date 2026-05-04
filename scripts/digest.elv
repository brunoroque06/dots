use re
use str

var last = 6
var cutOffHour = 36

fn get { |url|
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    --fail ^
    --retry 3 ^
    -s
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
  fn refind { |t|
    re:find '(?s)<item>.*?<'$t'>(.*?)</'$t'>.*?</item>' $html ^
      | each { |i| put $i[groups][1][text] }
  }
  var @titles = (refind title)
  var @links = (refind link)
  var @dates = (refind pubDate)
  var now = (date +%s)
  fn parse-date {|d|
    var z = Z
    if (or (str:contains $d +) (str:contains $d -)) {
      set z = z
    }
    date -j -f '%a, %d %b %Y %H:%M:%S %'$z $d +%s
  }
  each { |i|
    if (< (- $now (parse-date $dates[$i])) (* $cutOffHour 3600)) {
      put [&title=$titles[$i] &url=$links[$i]]
    }
  } [(range (count $titles))] ^
    | take $last ^
    | put [(all)]
}

fn gnews { |url| put 'https://news.google.com/rss/search?hl=en-US&gl=US&ceid=US%3Aen&q='$url }

fn report { |title items|
  printf $title"\n\n"
  fn clean-url { |u| str:split '?' $u | take 1 }
  each { |a| printf $a[title]' '(clean-url $a[url])"\n" } $items
  printf "\n"
}

