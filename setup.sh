#!/bin/bash
# author: Noel Colon
# description: Bulk app installer and professional setup for a development environment
# updated: May 23st, 2017

# TODOS: --------------------------------------------------------------------------------
# - Prompt installation option for IDE (sublime, atom, vscode) and install with brew cask
# - Provide presets for Vim if preferred
# ---------------------------------------------------------------------------------------

source `dirname $0`/utils.sh

# Ensure script has root permissions
# if [[ $EUID -ne 0 ]]; then
#   message_w "This script must run as root, use sudo"
#   exit 1
# fi

brews=(
    zsh
    ruby
    python
    node
    git
    mongodb
    elasticsearch
    redis
    libmemcached
)
casks=(
    iterm2
    p4merge
    postman
    robomongo
    docker
)
# Create Developer folder
create_dev_directory(){
  if ! [ "$1" == "test" ]; then
    local dir="$HOME/Developer"
    if [ ! -d $dir ]; then
      message_f "Creating $HOME/Developer directory"
      if mkdir $dir; then
        message_s "Successfully created $HOME/Developer directory"
      fi
    fi
  else
    return 0
  fi
}
# Install Homebrew
install_homebrew(){
  if ! command -v brew >/dev/null; then
    message_f "Installing Homebrew."
    curl -fsS \
      "https://raw.githubusercontent.com/Homebrew/install/master/install" | ruby
    brew doctor
  else
    message_f "Updating Homebrew from repo."
    if cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update 2>&1; then
      message_s "Homebrew successfully updated from repo."
    else
      message_e "Couldn't update Homebrew from repo."
    fi
  fi
}
# Install Brews
install_brews(){
  for pkg in ${brews[@]}; do
    if ! in_list $pkg "$(brew list)"; then
      message_f "Installing: $pkg"
      if brew install $pkg >/dev/null 2>&1; then
        message_s "Successfully installed: $pkg"
      else
        message_s "$pkg already installed"
      fi
    fi

    if in_list $pkg "$(brew outdated)"; then
      message_f "Updating: $pkg"
      if brew upgrade $pkg; then
        message_s "Successfully updated: $pkg"
      fi
    fi
  done
}
# Install Casks
install_casks(){
  for pkg in ${casks[@]}; do
    if ! in_list $pkg "$(brew cask list)"; then
      message_f "Installing: $pkg"
      if brew cask install $pkg >/dev/null 2>&1; then
        message_s "Successfully installed: $pkg"
      else
        message_s "$pkg already installed"
      fi
    fi

    if in_list $pkg "$(brew cask outdated)"; then
      message_f "Updating: $pkg"
      # http://stackoverflow.com/questions/31968664/upgrade-all-the-casks-installed-via-homebrew-cask
      if brew cask reinstall $pkg; then
        message_s "Successfully updated: $pkg"
      fi
    fi
  done
}
# Free up space after installing packages
brew_cleanup(){
  message_f "Running brew cleanup"
  if brew cleanup && brew cask cleanup; then
    message_s "Finished cleanup"
  fi
}
# Setup .gitconfig
setup_git_config(){
  local file="$HOME/.gitconfig"
  if ! -f $file >/dev/null 2>&1; then
    message_f "Setting up .gitconfig.."
    touch $file
    if echo "[branch]
      autosetuprebase = always
    [pull]
      rebase = true
    [push]
      default = simple
    [core]
      excludesfile = ~/.gitignore_global
    [credential]
      helper = osxkeychain
    [alias]
    # Show verbose output about tags, branches or remotes
      tags = tag -l
      branches = branch -a
      remotes = remote -v
    # Pretty log output
      hist = log --graph --pretty=format:'%Cred%h%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)%Creset [%an]' --abbrev-commit --date=relative" >> $file; then
        message_s "Finished setting up .gitconfig"
    else
        message_e "Failed setting up .gitconfig"
    fi
  fi 
}
# Make Zsh default shell
setup_zsh(){
  local shells="/etc/shells"
  local zsh=$(which zsh)
  if ! grep -qs "^$zsh$" "$shells"; then
    message_f "Adding Zsh to shells."
    if echo "$zsh" >> "$shells"; then
      message_s "Successfully added Zsh to shells."
    fi
  fi
  case "$SHELL" in
    */zsh) :
      message_s "Zsh already set up."
      ;;
    *)
      message_f "Making zsh default shell."
      if chsh -s /usr/local/bin/zsh; then
        message_s "Zsh set as default shell."
      else
        message_e "Could not set zsh as default shell."
      fi
      ;;
  esac
}
# Setup dev environment
setup_dev_environment(){
  create_dev_directory
  install_homebrew
  install_brews
  install_casks
  brew_cleanup
  setup_git_config
  setup_zsh
}

if ! [ "$1" == "test" ]; then
  setup_dev_environment
  echo "${star} Done ${star}"
fi