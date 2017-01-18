#Set prompt
rightprompt(){
	printf "%*s" $((${COLUMNS:-$(tput cols)} - 3)) "\$? @ \A"
}
PS1="\[$(tput sc; rightprompt; tput rc)\]\u@\h:\w\$ "
 
[[ -r ~/.commonrc ]] && source ~/.commonrc

