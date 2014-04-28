#Setup history
HISTFILE=~/.zsh_history
HISTSIZE=SAVEHIST=99999
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
bindkey -v
[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward
 
#Set prompt
PROMPT="%n@%M:%3~%# " RPROMPT="%? @ %T"
 
#Manage dir history
DIRSTACKSIZE=20
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'

#Don't overwrite existing files with > operator. Use >! to override.
setopt noclobber

#Don't grep .git dirs
export GREP_OPTIONS="--exclude-dir=.git"

#Functions
function findvim {
	find -iname "$1" -exec vim -p {} +
}

#Aliases
command -v truecrypt > /dev/null || alias truecrypt=realcrypt
alias ls='ls --color=auto'
alias diff='diff -u'
alias gitinit='git init && git add . && git commit -m Initial\ commit.'
alias tree='tree --charset=ascii'
alias wgetp='wget -EHkKp'
 
#for zsh
alias reloadzsh="source ~/.zshrc && echo zshrc reloaded"
alias zshrc="vim ~/.zshrc && reloadzsh"

#for gnu screen
alias sn='screen -S'
alias sa='screen -r'
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

if [ ! -z "${MY_PROXY}" ]; then
	export http_proxy=http://$MY_PROXY
	export HTTP_PROXY=$http_proxy
	export https_proxy=https://$MY_PROXY
	export HTTPS_PROXY=$https_proxy
fi

unset MAILCHECK
