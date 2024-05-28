#!/bin/bash

# Debugging: Output the current working directory
echo "Current directory: $(pwd)"

# Use ls to list directories and filter them accordingly
paths=$(ls -d ./devices/*/*/* 2>/dev/null | sed 's/^\.\///')

# Convert to JSON array format
json_paths=$(echo "$paths" | jq -R -s -c 'split("\n") | map(select(. != ""))')

# Output the JSON array
echo "$json_paths"
