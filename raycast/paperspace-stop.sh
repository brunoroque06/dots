#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Stop
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines stop --machineId ps8jo1fga
paperspace machines waitfor --machineId ps8jo1fga --state off
