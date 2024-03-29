#Setup history
HISTFILE=~/.zsh_history
HISTSIZE=SAVEHIST=10000
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

autoload -Uz compinit && compinit

# This automatically runs zkbd if the current $TERM doesn't have a file in .zkbd
autoload zkbd
function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    [[ -f ~/.zkbd/default ]] && printf '%s' ~/".zkbd/default" && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    echo "Could not find zkbd file for '${TERM}-${VENDOR}-${OSTYPE}' or '${TERM}-${DISPLAY}'" 
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward
 
#Set prompt
PROMPT="%n@%M:%3~%# " RPROMPT="%? @ %T"
 
# Use direnv if available
if command -v direnv > /dev/null; then
	eval "$(direnv hook zsh)"
fi

#Manage dir history
setopt autopushd pushdminus pushdsilent pushdtohome

#Don't overwrite existing files with > operator. Use >! to override.
setopt noclobber

#aliases
alias reloadsh="source ~/.zshrc && echo zshrc reloaded"
alias shrc="vim ~/.zshrc && reloadsh"


[[ -r ~/.commonrc ]] && source ~/.commonrc

