#!/bin/bash

packages_file="./output/Packages"

# Verify the Packages file exists and is not empty
if [ ! -s "$packages_file" ]; then
    echo "Error: Packages file is empty or does not exist."
    exit 1
fi

gzip -c "$packages_file" > "$packages_file.gz"
echo "Packages.gz file generated at $packages_file.gz"

# Debug: Verify Packages.gz file
echo "Contents of Packages.gz:"
gzip -d -c "$packages_file.gz" | cat
