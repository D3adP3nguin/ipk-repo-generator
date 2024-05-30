#!/bin/bash

# Read environment variables from GitHub Actions
device=$1
fw=$2
flavor=$3
category=$4

packages_file="./output/${device}/fw_${fw}/${flavor}/${category}/Packages"
sig_file="${packages_file}.sig"
usign_key="${USIGN_PRIVATE_KEY}"
usign_path="./output/usign"

# Create a temporary key file from the environment variable
temp_usign_key=$(mktemp)
if [ $? -ne 0 ]; then
    echo "Error: Failed to create a temporary file for the Usign key."
    exit 1
fi
echo "$usign_key" > "$temp_usign_key"

# Ensure the temp key file has the correct permissions
chmod 600 "$temp_usign_key"

# Check if the Packages file exists
if [ ! -f "$packages_file" ]; then
    echo "Error: Packages file $packages_file does not exist."
    rm "$temp_usign_key"
    exit 1
fi

# Check if the Usign binary exists
if [ ! -f "$usign_path" ]; then
    echo "Error: Usign binary $usign_path does not exist."
    rm "$temp_usign_key"
    exit 1
fi

echo "Packages file: $packages_file"
echo "Signature file: $sig_file"
echo "Usign private key: ***"
echo "Usign binary: $usign_path"
echo "Signing the Packages file..."

# Sign the Packages file
$usign_path -S -m "$packages_file" -s "$temp_usign_key" -x "$sig_file"
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    rm "$temp_usign_key"
    exit 1
fi

# Cleanup temporary key file
rm "$temp_usign_key"

echo "Packages.sig file generated at $sig_file"
