# dotfiles

These are my unix configuration files.

## How to set up a new machine

```bash
git clone git@github.com:dave-burke/dotfiles $HOME/dotfiles-tmp
mv dotfiles-tmp/.git $HOME/.dotfiles
dotfiles-tmp/.local/bin/init-dotfiles.sh
source .bashrc # or .zshrc
rm -rf dotfiles-tmp
rm -rf .dotfiles-backup # when you are happy with the result
```

Now you can use the `dotfiles` command just like `git` except it will work with the managed dotfiles in your local repository.

```bash
dotfiles pull
dotfiles status
dotfiles add .config/nvim/init.lua
dotfiles commit -m "Add nvim config"
dotfiles add .config/sway/config
dotfiles commit -m "Add sway config"
dotfiles push
```

## How it works

This is based on an ancient technique passed on by Unix masters since time immemorial.

I found it at: https://www.atlassian.com/git/tutorials/dotfiles

Which references: https://news.ycombinator.com/item?id=11070797

Where OP says: "I didn't invented it, I read it somewhere… but it was long time ago, I don't remember where."

Here's how it works:

1. There is a git directory in $HOME, but it is named `.dotfiles` instead of `.git`.
2. A `dotfiles` bash function wraps `git` to add `--git-dir="$HOME/.dotfiles" --work-tree="$HOME"` to the args (among other things -- see `.commonrc` in this repo).
3. The `.dotfiles` repo is configured with `status.showUntrackedFiles no` so `dotfiles status` only shows files that are explicitly managed.
4. The `.dotfiles` repo is configured with `core.sparseCheckout true` and the sparse checkout is configured to include everything except this README.

I made a couple improvements on the original article:

- My `.dotfiles` directory is set up like a regular non-bare repository. I found that this allows various operations to work more naturally. For example, with a bare repository, my log output didn't show remote branches from 'origin'.
- I added `sparseCheckout` config to prevent this README from being checked out to `$HOME`.
- My `dotfiles` command is a function instead of an alias, primarily so that it can add the `-u` flag when you run `dotfiles add` on a directory (so you can e.g. execute `dotfiles add .config` without adding all the untracked files in `.config`).
