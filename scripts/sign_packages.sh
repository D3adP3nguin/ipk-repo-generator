#!/bin/bash

packages_file=$1
sig_file=$2
usign_key=$3
usign_path=$4

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
