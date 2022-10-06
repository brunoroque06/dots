#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Paperspace Stop
# @raycast.mode compact
# @raycast.icon 🕹

paperspace machines stop --machineId ps5ljod8i
paperspace machines waitfor --machineId ps5ljod8i --state off
