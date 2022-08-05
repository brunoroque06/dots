#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Start
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines start --machineId psoxnh2i7
paperspace machines waitfor --machineId psoxnh2i7 --state ready
