#!/bin/bash

CMAKE_DIR=build
CMAKE_BUILD_TYPE=debug
CMAKE_GENERATOR='Sublime Text 2 - Unix Makefiles'

FILE_NAME=`basename "$0"`
FILE_FULLPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/${FILE_NAME}"

CMD_PREFIX=

function usage
{
cat <<EOF
Usage: ${FILE_NAME} [options] [type]

options:
	-h, -?        Print this help, then exit
	-s            Setup a project
	-c            Clean
	-e <command>  Run the command endlessly (break if the program fails)

type:
	debug (default)
	release

example:
	`basename "$0"` -e ./build/debug/bin/tests
EOF
}

while getopts "h?e:scv" opt; do
	case "$opt" in
	h|\?)
		usage
		exit 0
		;;
	s)
		rm -rfd "$CMAKE_DIR"
		CUR_DIR=`pwd`
		cd "${CUR_DIR}" && mkdir -p "$CMAKE_DIR/debug" && cd "$CMAKE_DIR/debug" && cmake -G "$CMAKE_GENERATOR" -DCMAKE_BUILD_TYPE=Debug ../..
		cd "${CUR_DIR}" && mkdir -p "$CMAKE_DIR/release" && cd "$CMAKE_DIR/release" && cmake -G "$CMAKE_GENERATOR" -DCMAKE_BUILD_TYPE=Release ../..
		exit 0
		;;
	c)
		rm -rfd "$CMAKE_DIR/bin" && mkdir -p "$CMAKE_DIR/bin"
		rm -rfd "$CMAKE_DIR/lib" && mkdir -p "$CMAKE_DIR/lib"
		exit 0
		;;
	v)
		CMD_PREFIX='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
		;;
	e)
		while ${CMD_PREFIX} ${OPTARG}; do :; done
		exit 1
		;;
	esac

done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

if [ "$#" -eq "1" ]; then
	CMAKE_BUILD_TYPE=$1
elif [ "$?" -gt "1" ]; then
	usage
	exit 1
fi

# Build the program
echo "Build type: '$CMAKE_BUILD_TYPE'"
if [ ! -f "${CMAKE_DIR}/.buildtype" ] || [ ! "`cat "${CMAKE_DIR}/.buildtype"`" == "$CMAKE_BUILD_TYPE" ]; then
	${FILE_FULLPATH} -c
fi
echo -n "$CMAKE_BUILD_TYPE" > "${CMAKE_DIR}/.buildtype"
cmake --build "$CMAKE_DIR/$CMAKE_BUILD_TYPE" -- -j3

