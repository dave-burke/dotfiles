#!/bin/bash

DOT_FILES="$(dirname ${0})"

function create_directory() {
	local dir_name="${1}"
	echo -n "Creating ${dir_name}..."
	if [[ -d "${dir_name}" ]]; then
		echo "Already exists"
	else
		mkdir --parents --verbose "${dir_name}"
	fi
}

function clone_repo() {
	local repo="${1}"
	local dest="${2}"

	if [[ -d "${dest}" ]]; then
		if [[ -d "${dest}/.git" ]]; then
			# I guess it could technically be a different repo, but that seems unlikely
			echo "${repo} is already cloned at ${dest}"
		else
			echo "${dest} already exists, but is not a git repository"
		fi
	else
		git clone ${repo} "${dest}"
	fi
}

function link_dotfile() {
	local target="$(cd $(dirname ${1}); pwd)/$(basename ${1})"
	local base_name="$(basename ${1})"
	local link_name="${HOME}/${base_name}"

	echo -n "Creating symlink to ${base_name}..."
	if [[ -e "${link_name}" ]]; then
		local do_overwrite
		if [[ "${force_overwrite}" == "true" ]]; then
			do_overwrite="y"
		else
			echo "${link_name} already exists. Overwrite?"
			read do_overwrite
		fi
		if [[ "${do_overwrite:0:1}" != "y" ]]; then
			echo "skipping ${base_name}"
			return
		fi
	fi
	ln --verbose --force --symbolic "${target}" "${link_name}"
}

if [[ "${1}" == "-f" ]]; then
	force_overwrite="true"
	shift
fi
echo "Creating symlinks for config files"

#This causes issues with the nested read command in link_dotfiles
#find "${DOT_FILES}/home" -type f -print0 | while IFS= read -r -d $'\0' f; do

for f in $(find "${DOT_FILES}/home"); do # This won't work if any files have spaces
	link_dotfile "${f}"
done

echo "Setting up VIM"

for d in backup undo swap bundle; do
	create_directory "${HOME}/.vim/${d}"
done

clone_repo "https://github.com/gmarik/Vundle.vim.git" "${HOME}/.vim/bundle/Vundle.vim"

vim +PluginInstall +qall

echo "Setting up Midnight Commander"

clone_repo "https://github.com/iwfmp/mc-solarized-skin.git" "${HOME}/.config/mc/lib/mc-solarized-skin"

echo "Done!"
