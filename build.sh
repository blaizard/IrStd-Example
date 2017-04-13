#!/bin/bash

CMAKE_DIR=build
CMAKE_GENERATOR='Sublime Text 2 - Unix Makefiles'

function usage {
cat <<EOF
Usage: `basename "$0"` [options]

options:
	-h, -?        Print this help, then exit
	-s            Setup a project
	-c            Clean
	-e <command>  Run the command endlessly (break if the program fails)

target:
	The name of the target

example:
	`basename "$0"` -e ./build/tests
EOF
}

while getopts "h?e:sc" opt; do
	case "$opt" in
	h|\?)
		usage
		exit 0
		;;
	s)
		mkdir -p "$CMAKE_DIR" && cd "$CMAKE_DIR" && cmake -G "$CMAKE_GENERATOR" ..
		exit 0
		;;
	c)
		rm -rfd "$CMAKE_DIR"
		;;
	e)
		while ${OPTARG}; do :; done
		exit 1
		;;
	esac

done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

# Build the program
cmake --build "$CMAKE_DIR" -- -j3

