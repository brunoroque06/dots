function prompt::dir
  set_color -b blue black
  printf ' %s ' (pwd | sed "s,^$HOME,~,")
end

function prompt::git
  set -l branch (git rev-parse --abbrev-ref HEAD)
  set -l stat (git status -s)
  if test -z "$stat"
    set_color -b green black
  else
    set_color -b yellow black
  end
  printf ' ⎇ %s ' "$branch"
end

function prompt::status
  set_color -b normal red
  if [ $argv[1] -ne 0 ]
    printf ' ✖'
  end
end

function prompt::lambda
  set_color -b normal magenta
  printf 'λ '
end

function fish_prompt
  set -l last_status $status
  printf '\n'
  prompt::dir
  prompt::git
  prompt::status $last_status
  printf '\n'
  prompt::lambda

  set_color -b normal normal
end
