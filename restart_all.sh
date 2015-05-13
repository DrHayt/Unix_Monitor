bin/tron --list | grep enabled | grep running | awk '{print $2}' | xargs -n1 bin/tron --stop 
