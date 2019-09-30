#!/bin/sh

# _ __ ___   __ _  ___ / _ \/ ___|
# | '_ ` _ \ / _` |/ __| | | \___ \
# | | | | | | (_| | (__| |_| |___) |
# |_| |_| |_|\__,_|\___|\___/|____/
#
# Setup script for macOS 
# - @riyaz-ali


# ---------- - - - - -
# Following part is taken from https://github.com/thoughtbot/laptop/blob/master/mac @ 581e50e

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n$fmt\\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\\n" "$text" >> "$zshrc"
    else
      printf "\\n%s\\n" "$text" >> "$zshrc"
    fi
  fi
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

# shellcheck disable=SC2016
append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

update_shell() {
  local shell_path;
  shell_path="$(command -v zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

case "$SHELL" in
  */zsh)
    if [ "$(command -v zsh)" != '/usr/local/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    append_to_zshrc '# recommended by brew doctor'

    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

# end of import from https://github.com/thoughtbot/laptop
# ---------- - - - - -

fancy_echo "Updating Homebrew formulae ..."
#brew update --force # https://github.com/Homebrew/brew/issues/1151
#brew upgrade  # Upgrade any already-installed formulae.

# includes tools from mathiasbynens/dotfiles, thoughtbot/laptop and few others that I personally use
brew bundle --file=- <<EOF
# additional formulae sources
tap "homebrew/services"
tap "caskroom/cask"

# Unix - common unix tools and utilities
brew "automake"
brew "binutils"
brew "cmake"
brew "curl"
brew "fzf"
brew "findutils"
brew "git"
brew "gnupg2"
brew "gnu-sed"
brew "jq"
brew "mkcert"
brew "moreutils"
brew "openssl"
brew "openssh"
brew "reattach-to-user-namespace"
brew "telnet"
brew "tmux"
brew "vim"
brew "watchman"
brew "zsh"

# Programming language prerequisites and package managers
brew "libyaml" # should come after openssl
brew "coreutils"
brew "yarn"

# Graphical tools
cask "alacritty"
cask "balenaetcher"
cask "postgres"
cask "motrix"
cask "vlc"
cask "visual-studio-code"
cask "google-chrome"
cask "google-backup-and-sync"

EOF

# Install oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh)
fancy_echo "Installing oh-my-zsh ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended || true  # ignore return code for oh-my-zsh
# oh-my-zsh installation fails if we already have an existing installation

# The best tmux config that just works! - https://github.com/gpakosz/.tmux
if [ ! -d ~/.tmux ]; then
  fancy_echo "Adding tmux config ..."
  git clone https://github.com/gpakosz/.tmux.git ~/.tmux
  ln -s -f ~/.tmux/.tmux.conf ~
  cp ~/.tmux/.tmux.conf.local ~
  fancy_echo "Customise the config by making change to ~/.tmux.conf.local - see https://github.com/gpakosz/.tmux"
else
  fancy_echo "Directory ~/.tmux exists.. skipping installation ..."
fi

# ---------- - - - - -
# Language tools ...

# Node.js Version manager (nvm)
fancy_echo "Installing Node Version manager (v0.34.0) ..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

# Ruby Version manager (rbenv)
fancy_echo "Installing Ruby Environment manager ..."
brew install rbenv
append_to_zshrc 'eval "$(rbenv init -)"'

# Java environment manager (jenv)
fancy_echo "Installing Java Environment ..."
brew install jenv

# ---------- - - - - -
