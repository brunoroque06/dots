use re
use str

var last = 10

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

fn rss { |url &gnews=$false|
  if (put $gnews) { set url = 'https://news.google.com/rss/search?hl=en-US&gl=US&ceid=US%3Aen&q='$url }
  var html = (get $url | slurp)
  fn refind { |t|
    re:find '(?s)<item>.*?<'$t'>(.*?)</'$t'>.*?</item>' $html ^
      | each { |i| put $i[groups][1][text] }
  }
  var @titles = (refind title)
  var @links = (refind link)
  each { |i| put [&title=$titles[$i] &url=$links[$i]] } [(range (count $titles))] ^
    | take $last ^
    | put [(all)]
}

fn report { |title items|
  printf $title"\n\n"
  fn clean-url { |u| str:split '?' $u | take 1 }
  each { |a| printf $a[title]' '(clean-url $a[url])"\n" } $items
  printf "\n"
}
