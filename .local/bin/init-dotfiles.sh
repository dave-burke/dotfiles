#!/bin/bash

set -e

/usr/bin/git clone --bare git@github.com:dave-burke/dotfiles $HOME/.dotfiles

cd $HOME

dotfiles() {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

echo "Hiding untracked files..."
dotfiles config --local status.showUntrackedFiles no

echo "Setting up sparse checkout..."
dotfiles config --local core.sparseCheckout true
echo '/*' > .dotfiles/info/sparse-checkout
echo '!/README.md' >> .dotfiles/info/sparse-checkout

echo "Backing up conflicting files..."
mkdir -p $HOME/.dotfiles-backup
dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | while read -r file; do
  mv -v "$file" "$HOME/.dotfiles-backup/"
done
dotfiles checkout -f

echo "Done. Don't forget to source .bashrc or .zshrc"
