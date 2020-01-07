function up --argument times
  set -q times[1]; or set times 1
  for i in (seq $times); cd ..; end;
end
