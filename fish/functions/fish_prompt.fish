function fish_prompt
  set -l last_status $status
  printf '\n'
  prompt::dir
  prompt::git
  prompt::status $last_status
  printf '\n'
  prompt::lambda
  set_color normal
end

function prompt::dir
  set_color blue
  printf '%s ' (pwd | sed "s,^$HOME,~,")
end

function prompt::git
  prompt::git::is_repo; or return
  if test -z (git status -s | head -n 1)
    set_color green
  else
    set_color yellow
  end
  printf '⎇ %s ' (git rev-parse --abbrev-ref HEAD)
end

function prompt::git::is_repo
  command git rev-parse --is-inside-work-tree ^/dev/null >/dev/null
end

function prompt::status
  set_color red
  if [ $argv[1] -ne 0 ]
    printf '✖'
  end
end

function prompt::lambda
  set_color magenta
  printf 'λ '
end
