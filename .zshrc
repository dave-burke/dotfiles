# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dave/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

PROMPT="%n@%M:%~%# "

DIRSTACKSIZE=8
alias dh='dirs -v'

setopt noclobber

#Don't grep .git dirs
export GREP_OPTIONS="--exclude-dir=.git"

#ALIASES
alias ls='ls --color=tty'
alias diff='diff -u'

#for gnu screen
alias sn='screen -S'
alias sr='screen -r'
alias sl='screen -ls'

#for tmux
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias tl='tmux ls'


alias cd..="cd .."
alias cd..2="cd ../.."
alias cd..3="cd ../../.."
alias cd..4="cd ../../../.."
alias cd..5="cd ../../../../.."
alias cd..6="cd ../../../../../.."
alias cd..7="cd ../../../../../../.."
alias cd..8="cd ../../../../../../../.."
alias cd..9="cd ../../../../../../../../.."

unset MAILCHECK
