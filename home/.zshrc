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

#Colors
if [[ -f ~/.dir_colors ]]; then
	eval `dircolors ~/.dir_colors`
fi

#Midnight Commander skin
export MC_SKIN="$HOME/.config/mc/lib/mc-solarized-skin/solarized.ini"

#Functions
function findvim {
	find -iname "$1" -exec vim -p {} +
}

function grepvim {
	# Only works for filenames without spaces. Boo!
	vim -p $(grep -rliI $@)
}

function swap {
	if [[ ! -f "${1}" ]]; then
		echo "${1} is not a file"
		return
	fi
	if [[ ! -f "${2}" ]]; then
		echo "${2} is not a file"
		return
	fi
	if [[ -f "tmp" ]]; then
		echo "tmp exists"
		return
	fi
	cp "${1}" tmp
	cp "${2}" "${1}"
	cp tmp "${2}"
	rm tmp
}

function findgrep {
	if [ $# -lt 2 ]; then
		echo Wrong number of arguments.
		return
	fi
	local findPattern=${1}
	local grepPattern=${2}
	shift 2
	if [ $# -gt 0 ]; then
		grepArgs=$@
	else
		grepArgs="-i"
	fi

	find -type f -iname "${findPattern}" -print0 | xargs -0 grep ${grepArgs} "${grepPattern}"
}

function odsgrep {
	for f in *.ods; do
		unzip -p $f content.xml | xmllint --format - | grep $@
		if [[ $? -eq 0 ]]; then
			echo $f
		fi
	done
}

alias cprv='rsync --recursive --perms --owner --group --backup-dir=/tmp/rsync --rsh /dev/null --human-readable --progress --'
function cpv {
	command -v pv > /dev/null
	if [[ $? -ne 0 ]]; then
		rsync --recursive --perms --owner --group --backup-dir=/tmp/rsync --rsh /dev/null --human-readable --progress -- $@
	else
		if [[ $# == 0 ]]; then
			echo "missing file operand"
			return
		elif [[ $# == 1 ]]; then
			echo "missing destination file operand after '${1}'"
			return
		fi

		local destination="${@: -1}"
		if [[ ! -e "${destination}" && $# > 2 ]]; then
			echo "target '${destination}' is not a directory"
			return
		fi

		if [[ -e "${destination}" && ! -d "${destination}" ]]; then
			echo "file exists: '${destination}'"
			return
		fi

		local a
		for a in "${@}"; do
			if [[ "${a}" != "${destination}" ]]; then
				if [[ -d "${a}" ]]; then
					#Fall back on rsync. Someday I'll sort this out.
					rsync --recursive --perms --owner --group --backup-dir=/tmp/rsync --rsh /dev/null --human-readable --progress -- "${a}" "${destination}"
				elif [[ -f "${a}" ]]; then
					if [[ -d "${destination}" ]]; then
						local target="${destination}/$(basename "${a}")"
					else
						local target="${destination}"
					fi
					#echo "${a} -> ${target}"
					pv -N "${a}" "${a}" > "${target}"
					chmod --reference "${a}" "${target}"
				else
					echo "${a} is not a normal file."
				fi
			fi
		done
	fi
}

#Aliases
command -v truecrypt > /dev/null || alias truecrypt=realcrypt
alias ls='ls --color=auto'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias lah='ls -lah'
alias diff='diff -u'
alias gitinit='git init && git add . && git commit -m Initial\ commit.'
alias treed='tree -d'
alias wgetp='wget --page-requisites --adjust-extension --span-hosts --convert-links --backup-converted'
alias grep='grep --exclude-dir=.git'

# GPG doesn't list keys in your keyring for some reason.
alias gpg-recipients='gpg --list-only --no-default-keyring --secret-keyring /dev/null'
 
#for zsh
alias reloadzsh="source ~/.zshrc && echo zshrc reloaded"
alias zshrc="vim ~/.zshrc && reloadzsh"

#for gnu screen
alias sn='screen -S'
alias sa='screen -r'
alias sl='screen -ls'

function mount_fat {
	sudo mount -v -t vfat -o umask=0022,uid=$(id -u),gid=$(id -g) "${1}" "${2}"
}

#for tmux
alias tmux='tmux -2' #Use 256 colors
function t {
	if [[ -z $1 ]]; then
		tmux ls
	else
		tmux attach -t $1
		if [[ $? -ne 0 ]]; then
			tmux new -s $1
		fi
	fi
}

alias cd..="cd .."
alias cd..2="cd ../.."
alias cd..3="cd ../../.."
alias cd..4="cd ../../../.."
alias cd..5="cd ../../../../.."
alias cd..6="cd ../../../../../.."
alias cd..7="cd ../../../../../../.."
alias cd..8="cd ../../../../../../../.."
alias cd..9="cd ../../../../../../../../.."

if [[ -f ~/.zshrc-local ]]; then
	source ~/.zshrc-local
fi
