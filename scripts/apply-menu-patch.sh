#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
patch_file="$repo_dir/patches/menu-only.patch"
target_file="$repo_dir/openvpn-install.sh"

if [[ ! -f "$target_file" ]]; then
	echo "Missing $target_file"
	exit 1
fi

if patch --dry-run -p1 -d "$repo_dir" < "$patch_file" >/dev/null; then
	patch -p1 -d "$repo_dir" < "$patch_file"
	bash -n "$target_file"
	echo "Applied menu patch."
elif patch --reverse --dry-run -p1 -d "$repo_dir" < "$patch_file" >/dev/null; then
	echo "Menu patch already applied."
	bash -n "$target_file"
else
	echo "Menu patch does not apply cleanly. Upstream likely changed this menu block."
	echo "Open $target_file, find the installed-server menu, and rebase patches/menu-only.patch."
	exit 1
fi
