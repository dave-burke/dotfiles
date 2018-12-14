#Set prompt
rightprompt(){
	printf "%*s" $((${COLUMNS:-$(tput cols)} - 3)) "\$? @ \A"
}
PS1="\[$(tput sc; rightprompt; tput rc)\]\u@\h:\w\$ "

# Use VIM keybindings
set -o vi
 
# Allow forward command searching via CTRL-S
[[ $- == *=* ]] && stty --ixon

# Keep dirs stack from getting too big
autopop(){
	while [[ $(dirs -p | wc -l) -gt $1 ]]; do
		popd -0 > /dev/null
	done
}
# Emulate autopushd from zsh
cdpushd(){
	if [[ $# -eq 0 ]]; then
		pushd "${HOME}" > /dev/null
	elif [[ "${1}" == "-" ]]; then
		pushd "$(dirs +1)" > /dev/null
	elif [[ "${1}" =~ ^-[0-9]+$ ]]; then
		pushd "$(dirs +${1:1})" > /dev/null
	else
		pushd "${1}" > /dev/null
	fi
	autopop $DIRSTACKSIZE
}
alias cd=cdpushd

#aliases
alias reloadsh="source ~/.bashrc && echo bashrc reloaded"
alias shrc="vim ~/.bashrc && reloadsh"

[[ -r ~/.commonrc ]] && source ~/.commonrc

