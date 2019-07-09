function weather --argument city
  set -q city[1]; or set city "Zurich"
  curl http://wttr.in/~$city
end
