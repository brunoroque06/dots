#!/usr/bin/env bash

is_command_not_in_path() { ! [ -x "$(command -v "$1")" ]; }

prompt_for_command() {
	read -p "Running command: $1. Are you sure? (Yy) " -n 1 -r
	printf '\n'
	if [[ $REPLY =~ Y|y ]]; then
		$1
	fi
}
