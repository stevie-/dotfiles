#!/usr/bin/env zsh
# shellcheck shell=bash

# Configuration
SIZE_LIMIT_MB=50
SIZE_LIMIT_BYTES=$((SIZE_LIMIT_MB * 1024 * 1024))

# 1. LOAD CUSTOM FUNCTIONS & ALIASES FROM YOUR ZSHRC
# shellcheck source=/dev/null
if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
fi

# 2. PRE-FLIGHT CUSTOM COMMAND VALIDATION
if ! command -v git-clone-organized > /dev/null 2>&1; then
    echo "❌ Error: Custom command 'git-clone-organized' not found." >&2
    echo "Please ensure it is defined in your ~/.zshrc and exported correctly." >&2
    exit 1
fi

echo "🔍 Searching for Git repositories down the tree..."
echo "--------------------------------------------------"

# Temporary files
TMP_FILE=$(mktemp /tmp/git_repos.XXXXXX)
SORTED_FILE=$(mktemp /tmp/git_repos_sorted.XXXXXX)
trap 'rm -f "$TMP_FILE" "$SORTED_FILE"' EXIT

# 3. Find all .git directories and calculate parent folder sizes
find . -type d -name ".git" 2>/dev/null | while read -r gitdir; do
    repo_dir=$(dirname "$gitdir")
    size_kb=$(du -sk "$repo_dir" | awk '{print $1}')
    size_bytes=$((size_kb * 1024))
    remote_url=$(git -C "$repo_dir" remote get-url origin 2>/dev/null || echo "No-Remote")
    size_human=$(du -sh "$repo_dir" | awk '{print $1}')

    printf "%s\t%s\t%s\t%s\n" "$size_bytes" "$size_human" "$repo_dir" "$remote_url" >> "$TMP_FILE"
done

if [ ! -s "$TMP_FILE" ]; then
    echo "No Git repositories found."
    exit 0
fi

# Save a sorted copy of the file so we don't need a pipeline later
sort -rn "$TMP_FILE" > "$SORTED_FILE"

# 4. Display all repos sorted by size decreasing
echo "📊 Repositories found (Sorted by size decreasing):"
printf "%-10s %-40s %s\n" "SIZE" "PATH" "REMOTE"
echo "--------------------------------------------------"
while read -r bytes human repo_path remote; do
    printf "%-10s %-40s %s\n" "$human" "$repo_path" "$remote"
done < "$SORTED_FILE"
echo "--------------------------------------------------"

# 5. Process repos that exceed the threshold
echo ""
echo "Checking for repositories larger than ${SIZE_LIMIT_MB}MB..."

# Open SORTED_FILE on File Descriptor 3 to leave standard input (FD 0) completely free
exec 3< "$SORTED_FILE"
while read -u 3 -r bytes human repo_path remote; do
    if [ "$bytes" -gt "$SIZE_LIMIT_BYTES" ]; then
        echo ""
        echo "⚠️  Found large repo: $repo_path ($human)"

        if [ "$remote" = "No-Remote" ]; then
            echo "❌ Skipping: Repository has no origin remote configured."
            continue
        fi

        printf "Do you want to drop and reclone this repo? (y/N): "
        read -r response

        if [[ "$response" =~ ^[Yy]$ ]]; then

            # 🛡️ NEW SAFETY CHECK: Test remote authentication before deletion
            echo "🔐 Verifying authentication connection to remote..."
            if ! git ls-remote "$remote" > /dev/null 2>&1; then
                echo "❌ Auth/Connection Error! Cannot reach or authenticate with $remote"
                echo "⏭️  Aborting removal of $repo_path to protect your data."
                continue
            fi

            echo "Removing: $repo_path..."
            rm -rf "$repo_path"

            echo "Re-cloning via git-clone-organized to $remote..."
            git-clone-organized "$remote"
        else
            echo "⏭️  Skipped."
        fi
    fi
done
exec 3<&- # Close File Descriptor 3

echo ""
echo "✅ Routine complete."
