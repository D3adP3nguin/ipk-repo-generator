#!/bin/bash

# Hardcoded paths
OUTPUT_DIR="./output"
USIGN_PATH="./repo/usign/build/usign"

# Ensure necessary directories exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$USIGN_PATH")"

# Function to extract control file from IPK
extract_control_from_ipk() {
    ipk_file=$1
    output_file=$2
    filename=$(basename "$ipk_file")

    # Extract the control.tar.gz from the IPK
    tar -xOf "$ipk_file" ./control.tar.gz > control.tar.gz
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract control.tar.gz from $ipk_file"
        rm control.tar.gz
        exit 1
    fi

    # List the contents of control.tar.gz for debugging
    echo "Contents of control.tar.gz:"
    tar -tzf control.tar.gz

    # Extract control file from control.tar.gz
    tar -xzOf control.tar.gz ./control >> "$output_file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract control file from control.tar.gz"
        rm control.tar.gz
        exit 1
    fi

    # Add Filename field
    echo "Filename: $filename" >> "$output_file"

    # Cleanup temporary files
    rm control.tar.gz
    echo "" >> "$output_file" # Add an empty line between entries
}

