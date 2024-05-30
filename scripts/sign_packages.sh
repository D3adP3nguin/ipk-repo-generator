#!/bin/bash

device="${device}"
fw="${fw}"
flavor="${flavor}"
category="${category}"
usign_key="${USIGN_PRIVATE_KEY}"

curated_packages_file="./output/${device}/${fw}/${flavor}/curated/Packages"
curated_sig_file="./output/${device}/${fw}/${flavor}/curated/Packages.sig"

supported_packages_file="./output/${device}/${fw}/${flavor}/supported/Packages"
supported_sig_file="./output/${device}/${fw}/${flavor}/supported/Packages.sig"

usign_path="./output/usign"

sign_package() {
    packages_file=$1
    sig_file=$2

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
        rm "$temp
