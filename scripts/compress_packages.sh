#!/bin/bash

# Path to the Packages file
PACKAGES_FILE="./output/${device}/${fw}/${flavor}/${category}/Packages"

# Check if the Packages file exists
if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Error: Packages file $PACKAGES_FILE does not exist."
    exit 1
fi

# Compress the Packages file
gzip -c "$PACKAGES_FILE" > "$PACKAGES_FILE.gz"

if [ $? -ne 0 ]; then
    echo "Error: Failed to compress the Packages file."
    exit 1
fi

echo "Packages.gz file generated at $PACKAGES_FILE.gz"
