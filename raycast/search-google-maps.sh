#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Search Google Maps
# @raycast.mode silent
# @raycast.icon 🔍
# @raycast.argument1 { "type": "text", "placeholder": "keyword(s)", "percentEncoded": true }

open "https://www.google.com/maps?oi=map&q=$1"
