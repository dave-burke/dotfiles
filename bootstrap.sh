#!/bin/bash

DOT_FILES="$(dirname ${0})"

# Just some boilerplate for consistent behavior and verbose output
function create_directory() {
	local dir_name="${1}"
	echo -n "Creating ${dir_name}..."
	if [[ -d "${dir_name}" ]]; then
		echo "Already exists"
	else
		mkdir --parents --verbose "${dir_name}"
	fi
}

function link_dotfile() {
	# target=/full/path/to/file ('realpath' is not always available or consistent)
	local target="$(cd $(dirname ${1}); pwd)/$(basename ${1})"
	local path_relative_to_home="${target##*/home/}"
	local link_name="${HOME}/${path_relative_to_home}"

	echo -n "Linking ${link_name} to ${target}"
	if [[ -e "${link_name}" ]]; then
		local do_overwrite
		if [[ "${force_overwrite}" == "true" ]]; then
			do_overwrite="y"
		else
			echo "${link_name} already exists. Overwrite?"
			read do_overwrite
		fi
		if [[ "${do_overwrite:0:1}" != "y" ]]; then
			echo "skipping ${path_relative_to_home}"
			return
		fi
	fi
	if [[ ! -d "$(dirname ${link_name})" ]]; then
		mkdir --verbose --parents "$(dirname ${link_name})"
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

for f in $(find "${DOT_FILES}/home" -type f); do # This won't work if any files have spaces
	link_dotfile "${f}"
done

echo "Setting up VIM"

for d in backup undo swap; do
	create_directory "${HOME}/.vim/${d}"
done

echo "Done!"
