#!/usr/bin/env sh

set -e

echo "🚀 omzsh installation"

if [ -d "${HOME}/.oh-my-zsh" ]; then
  printf "oh-my-zsh is already installed\n"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/057f3ec67e65661d3c01b757ec5cad0a3718453e/tools/install.sh)" "" --unattended
fi

ln -sf "${PWD}/omz/aliases.zsh" "${HOME}/.oh-my-zsh/custom/aliases.zsh"
ln -sf "${PWD}/omz/exports.zsh" "${HOME}/.oh-my-zsh/custom/exports.zsh"
ln -sf "${PWD}/omz/bind.zsh" "${HOME}/.oh-my-zsh/custom/bind.zsh"
