#!/bin/bash

packages_file=$1
sig_file=$2
usign_key=$3
usign_path=$4

echo "Signing the Packages file..."
echo "Packages file: $packages_file"
echo "Signature file: $sig_file"
echo "Usign path: $usign_path"
echo "Current working directory: $(pwd)"
echo "Files in current directory:"
ls -l
echo "Files in output directory:"
ls -l ./output

# Debug: Check the contents of the usign_key
echo "Contents of the key file:"
echo "$usign_key"

# Create a temporary key file from the environment variable
echo "$usign_key" > ./temp_usign_key

# Ensure the temp key file has the correct permissions
chmod 600 ./temp_usign_key

# Sign the Packages file
$usign_path -S -m $packages_file -s ./temp_usign_key -x $sig_file
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    exit 1
fi

# Cleanup temporary key file
rm ./temp_usign_key

echo "Packages.sig file generated at $sig_file"
