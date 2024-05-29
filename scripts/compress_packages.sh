#!/bin/bash

packages_file="./output/${device}/${fw}/${flavor}/${category}/Packages"
compressed_file="${packages_file}.gz"

if [ ! -f "$packages_file" ]; then
    echo "Error: Packages file $packages_file does not exist."
    exit 1
fi

gzip -c "$packages_file" > "$compressed_file"

if [ $? -ne 0 ]; then
    echo "Error: Failed to compress $packages_file."
    exit 1
fi

echo "Packages.gz file generated at $compressed_file"
