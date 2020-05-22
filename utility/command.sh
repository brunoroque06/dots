#!/usr/bin/env bash

is_command_not_in_path() { ! [ -x "$(command -v "$1")" ]; }
