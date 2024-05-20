#!/bin/bash

packages_file="./output/Packages"
manifest_file="./output/Packages.manifest"

# Verify the Packages file exists and is not empty
if [ ! -s "$packages_file" ]; then
    echo "Error: Packages file is empty or does not exist."
    exit 1
fi

md5sum "$packages_file" > "$manifest_file"
echo "Packages.manifest file generated at $manifest_file"

# Debug: Print the contents of the Packages.manifest file
echo "Contents of the Packages.manifest file:"
cat "$manifest_file"
