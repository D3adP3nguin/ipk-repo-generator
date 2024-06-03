#!/bin/bash

# Read the script arguments
device=$1
fw=$2
flavor=$3
category=$4

# Define the path to the Packages file and the compressed file
packages_file="./output/${device}/${fw}/${flavor}/${category}/Packages"
compressed_file="${packages_file}.gz"

# Check if the Packages file exists
if [ ! -f "$packages_file" ]; then
    echo "Error: Packages file $packages_file does not exist."
    exit 1
fi

# Compress the Packages file using gzip
gzip -c "$packages_file" > "$compressed_file"

# Check if the compression was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to compress $packages_file."
    exit 1
fi

# Output the location of the compressed file and its contents
echo "Packages.gz file generated at $compressed_file"
echo "Contents of Packages.gz file:"
gunzip -c "$compressed_file"
