#!/bin/bash

# Paths
packages_file="./output/Packages"
signature_file="./output/Packages.sig"
key_file="./keys/openWrtUsign.key"
usign_path="./repo/usign/build/usign"

echo "Signing the Packages file..."
echo "Packages file: $packages_file"
echo "Signature file: $signature_file"
echo "Key file: $key_file"
echo "Usign path: $usign_path"

"$usign_path" -S -m "$packages_file" -s "$key_file" -x "$signature_file"
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    exit 1
fi

echo "Packages.sig file generated at $signature_file"
