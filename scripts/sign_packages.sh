#!/bin/bash

# Paths
packages_file="./output/Packages"
signature_file="./output/Packages.sig"
key_file="./keys/openWrtUsign.key"
usign_path="./repo/usign/build/usign"

# Debug information
echo "Signing the Packages file..."
echo "Packages file: $packages_file"
echo "Signature file: $signature_file"
echo "Key file: $key_file"
echo "Usign path: $usign_path"

# Ensure the key file exists and is readable
if [ ! -f "$key_file" ]; then
    echo "Error: Key file does not exist."
    exit 1
fi
if [ ! -r "$key_file" ]; then
    echo "Error: Key file is not readable."
    exit 1
fi

# Ensure the usign binary exists and is executable
if [ ! -f "$usign_path" ]; then
    echo "Error: Usign binary does not exist."
    exit 1
fi
if [ ! -x "$usign_path" ]; then
    echo "Error: Usign binary is not executable."
    exit 1
fi

# Print the contents of the key file
echo "Contents of the key file:"
cat "$key_file"

# Print the permissions of the key file and usign binary
echo "Permissions of the key file:"
ls -l "$key_file"
echo "Permissions of the usign binary:"
ls -l "$usign_path"

# Attempt to sign the Packages file
"$usign_path" -S -m "$packages_file" -s "$key_file" -x "$signature_file"
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    exit 1
fi

echo "Packages.sig file generated at $signature_file"
