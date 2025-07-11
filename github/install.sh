#!/usr/bin/env sh

set -e

echo "🚀 GitHub configuration"

# Installation
gh extension install github/gh-copilot || true

# Upgrades
gh extension upgrade --all

# Config
mkdir -p "${HOME}/.config/gh/"
ln -sf "${PWD}/github/gh-config.yml" "${HOME}/.config/gh/config.yml"
