#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Show
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines show --machineId psoxnh2i7 | jq .state
