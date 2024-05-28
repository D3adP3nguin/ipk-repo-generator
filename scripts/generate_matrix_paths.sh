#!/bin/bash

# Find all relevant directories and output them in a JSON array format
paths=$(find ../devices -type d -mindepth 3 -maxdepth 3 | jq -R -s -c 'split("\n") | map(select(. != ""))')
echo "$paths"
