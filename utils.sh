# author: Noel Colon
# description: Utilities script for setup.sh
# updated: May 23st, 2017

# Text styling
bold=$(tput bold) # Bold
smul=$(tput smul) # Underline start
rmul=$(tput rmul) # Underline end
smso=$(tput smso) # Standout start
rmso=$(tput rmso) # Standout end
normal=$(tput sgr0) # Normalize text
# Foreground coloring
red=$(tput setaf 1)
green=$(tput setaf 46)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
# Fancy emojis/icons
star=✨
# Logging
message_s(){
  printf "${green}✔ %s${normal}\n" "$@"
}
message_w(){
  printf "${yellow}⚠ %s${normal}\n" "$@"
}
message_e(){
  printf "${red}✖ %s${normal}\n" "$@"
}
message_f(){
  printf "${blue}» %s${normal}\n" "$@"
}
# Validates whether item is in list.
# Arguments: 2
#   Arg1: item
#   Arg2: list
# Example: in_list node "$(brew list)"
in_list(){
  pkg=$1
  shift
  for item in $@; do
    if [ "$pkg" == "$item" ]; then
      return 0
    fi
  done
  return 1
}