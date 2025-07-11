#!/usr/bin/env sh

set -e

echo "🚀 git configuration"

# Check if the file exists and it RUNNING_IN_DEV_CONTAINER is false
# if [ ! -f "${HOME}/.gitconfig" ] && [ -z "${RUNNING_IN_DEV_CONTAINER}" ]; then
#   cp "${PWD}/git/.gitconfig.local" "${HOME}/.gitconfig.local"

#   echo "Enter your full name";
#   read -r var
#   sed -i '' "s|GITNAME|${var}|" "${HOME}/.gitconfig.local"

#   echo "Enter your email address";
#   read -r var
#   sed -i '' "s|GITEMAIL|${var}|" "${HOME}/.gitconfig.local"

#   echo "Entire the path to your public ssh key"
#   read -r var
#   sed -i '' "s|GITSIGNKEY|${var}|" "${HOME}/.gitconfig.local"
# fi

if [ ! -f "${HOME}/.gitconfig" ] && [ -z "${RUNNING_IN_DEV_CONTAINER}" ]; then
  ln -sf "${PWD}/git/.gitconfig" "${HOME}/.gitconfig"
fi
# on local machine, use local overwrites
if [ ! -f "${HOME}/.gitconfig.local" ] && [ -z "${RUNNING_IN_DEV_CONTAINER}" ]; then
  ln -sf "${PWD}/git/.gitconfig.local" "${HOME}/.gitconfig.local"
fi
if [ ! -f "${HOME}/.gitignore" ]; then
  ln -sf "${PWD}/git/.gitignore" "${HOME}/.gitignore"
fi

mkdir -p "${HOME}/.dotfiles/git"
# Create symlink for git-helpers
ln -sf "${PWD}/git/git-helpers.zsh" "${HOME}/.dotfiles/git/git-helpers.zsh"
