#!/bin/bash

# Hardcoded paths
OUTPUT_DIR="./output"
KEY_DIR="./keys"
USIGN_PATH="./repo/usign/build/usign"

# Ensure necessary directories exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$USIGN_PATH")"

# Function to extract control file from IPK
extract_control_from_ipk() {
    ipk_file=$1
    output_file=$2
    filename=$(basename "$ipk_file")

    echo "Extracting control file from $ipk_file..."

    # Debug: Check the IPK file format
    file "$ipk_file"

    # Decompress the IPK file (gzip compressed)
    gzip -d -c "$ipk_file" > temp.tar
    if [ $? -ne 0 ]; then
        echo "Error: Failed to decompress $ipk_file"
        exit 1
    fi

    # Debug: List contents of the decompressed tar file
    echo "Contents of temp.tar:"
    tar -tf temp.tar

    # Extract control.tar.gz from the tar archive
    tar --strip-components=1 -xf temp.tar ./control.tar.gz
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract control.tar.gz from $ipk_file"
        rm temp.tar
        exit 1
    fi

    # Debug: List contents of control.tar.gz
    echo "Contents of control.tar.gz:"
    tar -tzf control.tar.gz

    # Extract control file from control.tar.gz
    tar -xzOf control.tar.gz ./control >> "$output_file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract control file from control.tar.gz"
        rm temp.tar control.tar.gz
        exit 1
    fi

    # Add Filename field
    echo "Filename: $filename" >> "$output_file"

    # Cleanup temporary files
    rm temp.tar control.tar.gz
    echo "" >> "$output_file" # Add an empty line between entries
}

# Function to generate Packages file
generate_packages() {
    ipk_dir=$1
    output_file=$2

    echo "Generating Packages file..."
    > "$output_file" # Empty the file

    # Debug: List all IPK files found
    echo "Looking for IPK files in $ipk_dir"
    find "$ipk_dir" -type f -name '*.ipk'

    find "$ipk_dir" -type f -name '*.ipk' | while read -r ipk; do
        echo "Processing IPK file: $ipk"
        extract_control_from_ipk "$ipk" "$output_file"
    done

    echo "Packages file generated at $output_file"
    # Debug: Print the contents of the Packages file
    echo "Contents of the Packages file after generation:"
    cat "$output_file"
}

# Main script
ipk_dir="./repo/IPK_files"
packages_file="$OUTPUT_DIR/Packages"

generate_packages "$ipk_dir" "$packages_file"

# Verify the Packages file is not empty
if [ ! -s "$packages_file" ]; then
    echo "Error: Packages file is empty or does not exist."
    exit 1
fi
