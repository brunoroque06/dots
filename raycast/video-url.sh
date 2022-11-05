#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Video URL
# @raycast.mode compact
# @raycast.icon 🎬

streamlink --stream-url "$(pbpaste)" best | pbcopy
