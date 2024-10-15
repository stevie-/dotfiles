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

# on local machine, use git+ssh instead of https with ssh-agent
if [ ! -f "${HOME}/.gitconfig" ] && [ -z "${RUNNING_IN_DEV_CONTAINER}" ]; then
cat << EOF >> "${PWD}/git/.gitconfig.local"

# Use git+ssh instead of https
[url "git@github.com:"]
insteadOf = "https://github.com/"

EOF
fi

ln -sf "${PWD}/git/.gitconfig" "${HOME}/.gitconfig"
ln -sf "${PWD}/git/.gitignore" "${HOME}/.gitignore"
