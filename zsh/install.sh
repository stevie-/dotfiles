#!/usr/bin/env sh

set -e

echo "🚀 zsh installation"

ln -sf "${PWD}/zsh/.zshrc" "${HOME}/.zshrc"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
