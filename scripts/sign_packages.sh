#!/bin/bash

# Usage: ./sign_packages.sh <packages_file> <output_signature_file> <usign_private_key> <usign_binary_path>

packages_file=$1
output_signature_file=$2
usign_private_key=$3
usign_binary_path=$4

# Check if the packages file exists
if [ ! -f "$packages_file" ]; then
    echo "Error: Packages file $packages_file does not exist."
    exit 1
fi

# Check if the Usign binary exists
if [ ! -f "$usign_binary_path" ]; then
    echo "Error: Usign binary $usign_binary_path does not exist."
    exit 1
fi

# Check if the Usign private key is provided
if [ -z "$usign_private_key" ]; then
    echo "Error: Usign private key is not provided."
    exit 1
fi

# Sign the Packages file
echo "$usign_private_key" | "$usign_binary_path" sign -m "$packages_file" -o "$output_signature_file"
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file."
    exit 1
fi

echo "Packages file signed successfully."
