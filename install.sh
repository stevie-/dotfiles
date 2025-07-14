#!/usr/bin/env sh

set -e

# Component definitions
DEFAULT_COMPONENTS="omz zsh git"
DEV_COMPONENTS="brew github k9s neovim"
ALL_COMPONENTS="$DEFAULT_COMPONENTS $DEV_COMPONENTS"

# Check if running in dev containers
if [ -n "${CODESPACES}" ] || [ -n "${REMOTE_CONTAINERS}" ]; then
  export RUNNING_IN_DEV_CONTAINER=1
  echo "🏃 Running in dev container"
fi

# Function to install specific component
install_component() {
    # Check if component exists
    echo "$ALL_COMPONENTS" | grep -w -q "$1" || {
        echo "❌ Unknown component: $1"
        exit 1
    }

    # Install based on component type
    if echo "$DEFAULT_COMPONENTS" | grep -w -q "$1"; then
        "./$1/install.sh"
    elif echo "$DEV_COMPONENTS" | grep -w -q "$1"; then
        [ -z "${RUNNING_IN_DEV_CONTAINER}" ] && "./$1/install.sh"
    fi
}

# Install components
if [ $# -eq 0 ]; then
    # Install default components
    for component in $DEFAULT_COMPONENTS; do
        install_component "$component"
    done

    # Install dev components if not in container
    if [ -z "${RUNNING_IN_DEV_CONTAINER}" ]; then
        for component in $DEV_COMPONENTS; do
            install_component "$component"
        done
    fi
else
    # Install specific components
    for component in "$@"; do
        install_component "$component"
    done
fi

# Manual notifications
echo "🚀 Manual installation/updates"
echo "OMZ: omz update"
echo ""
echo "🚀 Suggestions to tidy"
echo "- ~/Library/Appliation Support"
