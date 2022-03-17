#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Search YouTube
# @raycast.mode silent
# @raycast.icon 🔍
# @raycast.argument1 { "type": "text", "placeholder": "keyword(s)", "percentEncoded": true }

open "https://www.youtube.com/results?search_query=$1"
