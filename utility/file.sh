#!/usr/bin/env bash

symlink_to_dir() {
	readonly FILE=$1
	readonly TARGET_DIR=$2
	readonly AB_PATH="$(
		cd "$(dirname "$0")" || exit
		pwd -P
	)"
	mkdir -p "$TARGET_DIR"
	readonly FILE_NAME=$(basename "$FILE")
	ln -fsv "$AB_PATH"/"$FILE" "$TARGET_DIR"/"$FILE_NAME"
}
