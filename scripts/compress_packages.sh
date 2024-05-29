#!/bin/bash

echo "Compressing the Packages file"
# Compress the Packages file
gzip -k -f ./output/Packages

if [ $? -eq 0 ]; then
    echo "Packages file compressed to Packages.gz"
else
    echo "Error: Failed to compress Packages file"
    exit 1
fi
