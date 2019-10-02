#!/usr/bin/env bash

symlink_to_dir() {
	FILE=$1
	TARGET_DIR=$2
	AB_PATH="$(
		cd "$(dirname "$0")" || exit
		pwd -P
	)"
	mkdir -p "$TARGET_DIR"
	FILE_NAME=$(basename "$FILE")
	ln -fsv "$AB_PATH"/"$FILE" "$TARGET_DIR"/"$FILE_NAME"
}
