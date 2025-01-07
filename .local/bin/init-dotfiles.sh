#!/bin/bash

set -e

export GIT_DIR=$HOME/.dotfiles
export GIT_WORK_TREE=$HOME

cd $GIT_WORK_TREE

echo "Hiding untracked files..."
git config --local status.showUntrackedFiles no

echo "Setting up sparse checkout..."
git config --local core.sparseCheckout true
echo '/*' > .dotfiles/info/sparse-checkout
echo '!/README.md' >> .dotfiles/info/sparse-checkout

echo "Backing up conflicting files..."
mkdir -p $HOME/.dotfiles-backup
git checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | while read -r file; do
  if [[ -f $file ]]; then
    mv -v "$file" "$HOME/.dotfiles-backup/"
  fi
done
git checkout

echo "Done. Don't forget to source .bashrc or .zshrc"
