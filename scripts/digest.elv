use re

# set-env COPILOT_GITHUB_TOKEN ...

var news = []

fn get { |url|
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    -s
}

fn get-comp { |url|
  curl $url ^
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15' ^
    -H 'Accept-Language: en-US,en;q=0.9' ^
    -H 'Priority: u=0, i' ^
    --compressed ^
    --output index.html ^
    -s
  defer { rm index.html }
  cat index.html
}

fn reddit { |sub|
  get 'https://www.reddit.com/r/'$sub'/hot.json?limit=5' ^
    | from-json ^
    | put (one)[data][children] ^
    | all (one) ^
    | each { |e| put [&title=$e[data][title] &url='https://www.reddit.com'$e[data][permalink]] } ^
    | put [(all)]
}

fn append { |title items|
  # var fmted = (each { |i| put $i[title]', '$i[url] } $items | put [(all)])
  set news = [$@news [&title=$title &news=$items]]
}

fn digest { |url &comp=$false|
  var html = (if (put $comp) { get-comp $url } else { get $url } | slurp)
  printf $html > index.html
  defer { rm index.html }
  var titles = (
    re:find '(?s)<a(.*?)</a>' (cat index.html | slurp) ^
      | each { |i| put $i[groups][0][text] } ^
      | put [(all)]
    )
  each { |i| echo $i } $titles > index.html
  try {
    /opt/homebrew/bin/copilot -p 'Output json. Read index.html, output title and url for the 5 most important news' -s ^
      | slurp ^
      | re:find '(?s)```json(.*)```' (one) ^
      | printf (one)[groups][1][text] ^
      | from-json
  } catch _ {
    put []
  }
}

each { |n|
  printf $n[title]"\n\n"
  each { |a| printf $a[title]"\n\t"$a[url]"\n" } $n[news]
  printf "\n"
} $news
