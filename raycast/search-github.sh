#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Search GitHub
# @raycast.mode silent
# @raycast.icon 🔍
# @raycast.argument1 { "type": "text", "placeholder": "keyword(s)", "percentEncoded": true }

open "https://github.com/search?q=$1"
