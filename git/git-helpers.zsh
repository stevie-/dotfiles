create-githost-gitconfig() {
  local parent_dir="$(dirname "$(git rev-parse --show-toplevel)")"
  local githost_config_file="$parent_dir/../gitconfig"
  local gitowner_config_file="$parent_dir/gitconfig"

  if [[ ! -f "$githost_config_file" ]]; then
    echo "Creating parent gitconfig at $githost_config_file"
    cat >"$githost_config_file" <<EOL
# githost-specific git configuration
# This file is automatically included by local gitowner gitconfig (double include starting at repo level)
# Uncomment and modify if you want different user settings for this scope
[user]
    #signingkey =
    #name = Your Name
    #email = your.email@example.com
EOL
  fi

  if [[ ! -f "$gitowner_config_file" ]]; then
    echo "Creating parent gitconfig at $gitowner_config_file"
    cat >"$gitowner_config_file" <<EOL
# githost-specific git configuration
# This file is automatically included by local (repo) gitconfig
[include]
  path = ../gitconfig

# Uncomment and modify if you want different user settings for this scope
[user]
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
    # git@github.com:owner/repo[.git]
    host=$(echo "$url" | sed -E 's#git@([^:]+):.*#\1#')
    owner=$(echo "$url" | sed -E 's#git@[^:]+:([^/]+).*#\1#')
    repo=$(echo "$url" | sed -E 's#git@[^:]+:[^/]+/([^/.]+).*#\1#')
  elif [[ "$url" == ssh://* ]]; then
    # ssh://[git@]host[:port]/owner/repo[.git]
    host=$(echo "$url" | sed -E 's#ssh://([^@/]+@)?([^:/]+).*#\2#')
    owner=$(echo "$url" | sed -E 's#ssh://([^@/]+@)?[^:/]+:[0-9]+/([^/]+).*#\2#')
    repo=$(echo "$url" | sed -E 's#ssh://([^@/]+@)?[^:/]+:[0-9]+/[^/]+/([^/.]+).*#\2#')
  elif [[ "$url" == http*://* ]]; then
    # https://host/owner/repo[.git]
    host=$(echo "$url" | sed -E 's#https?://([^/]+)/.*#\1#')
    owner=$(echo "$url" | sed -E 's#https?://[^/]+/([^/]+).*#\1#')
    repo=$(echo "$url" | sed -E 's#https?://[^/]+/[^/]+/([^/.]+).*#\1#')
  else
    echo "Unrecognized URL format: $url"
    return 1
  fi

  # Validation
  if [[ -z "$host" || -z "$owner" || -z "$repo" ]]; then
    echo "Failed to parse URL components:"
    echo "Host: $host"
    echo "Owner: $owner"
    echo "Repo: $repo"
    return 1
  fi

  local target_dir="$basepath/$host/$owner/$repo"

  echo "Cloning into: $target_dir"
  mkdir -p "$target_dir"
  git clone "$url" "$target_dir"
  (cd "$target_dir" && create-githost-gitconfig)

  local config_file="$target_dir/.git/config"
  local include_path="../../gitconfig"

  # check if Include exists in config
  if ! grep -q "\[include\]" "$config_file"; then
    echo "" >>"$config_file"
    echo "[include]" >>"$config_file"
    echo "    path = $include_path" >>"$config_file"
    echo "Added include to $config_file"
  fi
}
