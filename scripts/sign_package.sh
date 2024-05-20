#!/bin/bash

# Paths
PACKAGES_FILE=$1
SIGNATURE_FILE=$2
KEY_FILE=$3
USIGN_PATH=$4

# Debug information
echo "Signing the Packages file..."
echo "Packages file: $PACKAGES_FILE"
echo "Signature file: $SIGNATURE_FILE"
echo "Key file: $KEY_FILE"
echo "Usign path: $USIGN_PATH"

# Print the contents of the key file
echo "Contents of the key file:"
cat "$KEY_FILE"

# Attempt to sign the Packages file
"$USIGN_PATH" -S -m "$PACKAGES_FILE" -s "$KEY_FILE" -x "$SIGNATURE_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to sign the Packages file"
    exit 1
fi

echo "Packages.sig file generated at $SIGNATURE_FILE"
