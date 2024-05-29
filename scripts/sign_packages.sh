#!/bin/bash

# Ensure the script is executed with the correct number of arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <packages_file> <signature_file> <usign_private_key> <usign_binary>"
    exit 1
fi

packages_file=$1
signature_file=$2
usign_private_key=$3
usign_binary=$4

# Debugging: Print the paths and check if files exist
echo "Packages file: $packages_file"
echo "Signature file: $signature_file"
echo "Usign private key: $usign_private_key"
echo "Usign binary: $usign_binary"

if [ ! -f "$packages_file" ]; then
    echo "Error: Packages file $packages_file does not exist."
    exit 1
fi

if [ ! -f "$usign_binary" ]; then
    echo "Error: Usign binary $usign_binary does not exist."
    exit 1
fi

# Sign the Packages file
echo "Signing the Packages file..."
$usign_binary -S -m $packages_file -s $usign_private_key -o $signature_file
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    exit 1
fi

echo "Packages file signed successfully"
