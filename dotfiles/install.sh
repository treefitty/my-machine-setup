#!/usr/bin/env bash
# Symlink every file in this dir into $HOME (an existing real file is moved to <name>.bak)
set -eo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)

cd "$HERE"
find . -type f ! -name install.sh ! -name .DS_Store | while read -r f; do
  f=${f#./}
  mkdir -p "$(dirname "$HOME/$f")"
  if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then mv "$HOME/$f" "$HOME/$f.bak"; fi
  ln -sfn "$HERE/$f" "$HOME/$f"
done
