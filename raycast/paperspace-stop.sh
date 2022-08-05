#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Stop
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines stop --machineId psoxnh2i7
paperspace machines waitfor --machineId psoxnh2i7 --state off
