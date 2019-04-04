function weather --argument city
  set -q city[1]; or set city "Bern"
  curl http://wttr.in/~$city
end