#Set prompt
rightprompt(){
	printf "%*s" $COLUMNS "\$? @ \A   " 2> /dev/null || echo -n ""
}
PS1="\[$(tput sc; rightprompt; tput rc)\]\u@\h:\w\$ "
 
[[ -r ~/.commonrc ]] && source ~/.commonrc

