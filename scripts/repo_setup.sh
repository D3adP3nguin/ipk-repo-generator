#!/bin/bash

# Read environment variables from GitHub Actions
device=$1
fw=$2
flavor=$3
category=$4

# Create necessary directories
mkdir -p ./output/${device}/${fw}/${flavor}/${category}

# Copy the precompiled Usign binary to the output directory
cp ./usign/build/usign ./output/usign
echo "Copied usign binary"

# Set execute permissions for the Usign binary
chmod +x ./output/usign
echo "Set execute permissions for usign"

# Copy precompiled IPKs to the output directory
echo "Copying IPK files from devices/${device}/${fw}/${flavor}/${category} to ./output/${device}/${fw}/${flavor}/${category}/"
find devices/${device}/${fw}/${flavor}/${category} -type f -name '*.ipk' -exec cp {} ./output/${device}/${fw}/${flavor}/${category}/ \;
echo "IPK files in ./output/${device}/${fw}/${flavor}/${category}/:"
ls -l ./output/${device}/${fw}/${flavor}/${category}/
