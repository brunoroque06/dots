#!/usr/bin/env bash

symlink_to_dir() {
	local FILE=$1
	local TARGET_DIR=$2
	local AB_PATH
	AB_PATH="$(
		cd "$(dirname "$0")" || exit
		pwd -P
	)"
	mkdir -p "$TARGET_DIR"
	local FILE_NAME
	FILE_NAME=$(basename "$FILE")
	ln -fsv "$AB_PATH"/"$FILE" "$TARGET_DIR"/"$FILE_NAME"
}
