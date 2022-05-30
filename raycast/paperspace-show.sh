#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Show
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines show --machineId ps8jo1fga | jq .state
