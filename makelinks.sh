#!/bin/bash
cd $(dirname ${BASH_SOURCE[0]})
for f in $(find -maxdepth 1 -type f -name "\.*"); do
	ln -rfs $(pwd)/$f ~/$f
done
