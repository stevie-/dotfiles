#!/usr/bin/env zsh

set -e

echo "🚀 AI configuration"

mkdir -p ~/.claude/skills/

SCRIPTDIR=$(cd "$(dirname "${(%):-%N}")" && pwd)
source "${SCRIPTDIR}/../git/git-helpers.zsh"

git-clone-organized https://github.com/antonbabenko/terraform-skill
ln -s "$HOME/Documents/Projects/git/github.com/antonbabenko/terraform-skill" ~/.claude/skills/terraform-skill

