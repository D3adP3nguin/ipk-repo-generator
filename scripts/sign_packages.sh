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

# Print current working directory
echo "Current working directory:"
pwd

# List files in current directory
echo "Files in current directory:"
ls -l

# List files in output directory
echo "Files in output directory:"
ls -l ./output

# List files in keys directory
echo "Files in keys directory:"
ls -l ./keys

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

# Ensure the Packages file is not empty
if [ ! -s "$packages_file" ]; then
    echo "Error: Packages file is empty or does not exist."
    exit 1
fi

# Print the contents of the Packages file
echo "Contents of the Packages file:"
cat "$packages_file"

# Print the contents of the key file
echo "Contents of the key file:"
cat "$key_file"

# Print the permissions of the key file and usign binary
echo "Permissions of the key file:"
ls -l "$key_file"
echo "Permissions of the usign binary:"
ls -l "$usign_path"

# Attempt to sign the Packages file and capture the output
sign_command="$usign_path -S -m $packages_file -s $key_file -x $signature_file"
echo "Executing sign command: $sign_command"
output=$($sign_command 2>&1)
result=$?
echo "Command output: $output"

if [ $result -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    exit 1
fi

echo "Packages.sig file generated at $signature_file"
