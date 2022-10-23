#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Open Video
# @raycast.mode compact
# @raycast.icon 🎬

open "$(streamlink --stream-url "$(pbpaste)" best)"
