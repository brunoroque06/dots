#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Search Google
# @raycast.mode silent
# @raycast.icon 🔍
# @raycast.argument1 { "type": "text", "placeholder": "keyword(s)", "percentEncoded": true }

open "https://www.google.com/search?q=$1"
