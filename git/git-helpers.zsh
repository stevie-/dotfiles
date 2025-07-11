create-githost-gitconfig() {
  local parent_dir="$(dirname "$(git rev-parse --show-toplevel)")"
  local githost_config_file="$parent_dir/../gitconfig"
  local gitowner_config_file="$parent_dir/gitconfig"

  if [[ ! -f "$githost_config_file" ]]; then
    echo "Creating parent gitconfig at $githost_config_file"
    cat >"$githost_config_file" <<EOL
# githost-specific git configuration
# This file is automatically included by global gitconfig
[user]
    # Uncomment and modify if you want different user settings for this scope
    #signingkey =
    #name = Your Name
    #email = your.email@example.com
EOL
  fi
  if [[ ! -f "$gitowner_config_file" ]]; then
    echo "Creating parent gitconfig at $gitowner_config_file"
    cat >"$gitowner_config_file" <<EOL
# githost-specific git configuration
# This file is automatically included by global gitconfig
[user]
    # Uncomment and modify if you want different user settings for this scope
    #signingkey =
    #name = Your Name
    #email = your.email@example.com
EOL
  fi
}

git-clone-organized() {
  local basepath="$HOME/Projects/git"
  local url="$1"

  if [[ -z "$url" ]]; then
    echo "Usage: $0 <git-url>"
    return 1
  fi

  local host owner repo

  if [[ "$url" == git@*:* ]]; then
    # git@host:owner/repo.git
    host=$(echo "$url" | sed -E 's#git@([^:]+):.*#\1#')
    owner=$(echo "$url" | sed -E 's#git@[^:]+:([^/]+)/.*#\1#')
    repo=$(echo "$url" | sed -E 's#git@[^:]+:[^/]+/([^/]+)\.git#\1#')
  elif [[ "$url" == ssh://git@* ]]; then
    # ssh://git@host:port/owner/repo.git
    host=$(echo "$url" | sed -E 's#ssh://git@([^:/]+):[0-9]+/.*#\1#')
    owner=$(echo "$url" | sed -E 's#ssh://git@[^:/]+:[0-9]+/([^/]+)/.*#\1#')
    repo=$(echo "$url" | sed -E 's#ssh://git@[^:/]+:[0-9]+/[^/]+/([^/]+)\.git#\1#')
  elif [[ "$url" == ssh://* ]]; then
    # ssh://host:port/owner/repo.git (ohne Benutzername)
    host=$(echo "$url" | sed -E 's#ssh://([^:/]+):[0-9]+/.*#\1#')
    owner=$(echo "$url" | sed -E 's#ssh://[^:/]+:[0-9]+/([^/]+)/.*#\1#')
    repo=$(echo "$url" | sed -E 's#ssh://[^:/]+:[0-9]+/[^/]+/([^/]+)\.git#\1#')
  elif [[ "$url" == http*://* ]]; then
    # https://host/owner/repo.git
    host=$(echo "$url" | sed -E 's#https?://([^/]+)/.*#\1#')
    owner=$(echo "$url" | sed -E 's#https?://[^/]+/([^/]+)/.*#\1#')
    repo=$(echo "$url" | sed -E 's#https?://[^/]+/[^/]+/([^/]+)\.git#\1#')
  else
    echo "Unrecognized URL format: $url"
    return 1
  fi

  local target_dir="$basepath/$host/$owner/$repo"

  echo "Cloning into: $target_dir"
  mkdir -p "$target_dir"
  git clone "$url" "$target_dir"
  (cd "$target_dir" && create-githost-gitconfig)
}
