#!/usr/bin/env bash

set -e

if test ! "$(which brew)"; then
  echo "🚀 Installing the brew package manager"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

###
# Install brew packages
###
echo "🚀 Installing brew packages"

# Taps

BASE_PACKAGES=(
  amazon-ecs-cli
  autojump
  aws-iam-authenticator
  aws-sam-cli
  awscli
  azure-cli
  base64
  bat
  cloud-nuke
  commitizen
  coreutils
  fzf
  gh
  git
  gnupg
  go
  helm
  htop
  hub
  infracost
  ipcalc
  jq
  k9s
  kubectx
  kubernetes-cli
  neovim
  nmap
  node
  nodeenv
  openjdk
  parallel
  pipx
  pre-commit
  pyenv
  pyenv-virtualenv
  python@3.10
  readline
  ruby
  shellcheck
  shfmt
  tenv
  terraform-docs
  tflint
  tfsec
  tig
  tree
  watch
  wget
  yq
  zsh-completions
  zsh-syntax-highlightin
)

# if [ "$(arch)" = "arm64" ]; then
#   BASE_PACKAGES+=(
#   )
# fi

for pkg in "${BASE_PACKAGES[@]}"; do printf "installing %s\n" "${pkg}" && brew install "${pkg}"; done

# Casks (only on Mac)
# if [ "$(arch)" = "arm64" ]; then
# fi

# Some tidying up
brew autoremove -v
brew cleanup --prune=all
