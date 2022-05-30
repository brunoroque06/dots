#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Start
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines start --machineId ps8jo1fga
paperspace machines waitfor --machineId ps8jo1fga --state ready
