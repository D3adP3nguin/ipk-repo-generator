#!/bin/bash

# Debugging: Output the current working directory
echo "Current directory: $(pwd)"

# Use ls to list directories and filter them accordingly
paths=$(ls -d devices/*/*/*/* 2>/dev/null)

# Output the paths with the required indentation
echo "Generated paths:"
echo "$paths" | while read -r path; do
    echo "          - ${path}"
done
