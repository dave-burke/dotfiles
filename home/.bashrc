#Set prompt
rightprompt(){
	printf "%*s" $((${COLUMNS:-$(tput cols)} - 3)) "\$? @ \A"
}
PS1="\[$(tput sc; rightprompt; tput rc)\]\u@\h:\w\$ "

# Use VIM keybindings
set -o vi
 
# Allow forward command searching via CTRL-S
[[ $- == *=* ]] && stty --ixon

[[ -r ~/.commonrc ]] && source ~/.commonrc

# Keep dirs stack from getting too big
autopop(){
	while [[ $(dirs -p | wc -l) -gt $1 ]]; do
		popd -0 > /dev/null
	done
}
# Emulate autopushd from zsh
cd(){
	if [[ $# -eq 0 ]]; then
		pushd "${HOME}" > /dev/null
	elif [[ "${1}" == "-" ]]; then
		pushd "$(dirs +1)" > /dev/null
	elif [[ "${1}" =~ -[0-9]+ ]]; then
		pushd "$(dirs +${1:1})" > /dev/null
	else
		pushd ${1} > /dev/null
	fi
	autopop 20
}
