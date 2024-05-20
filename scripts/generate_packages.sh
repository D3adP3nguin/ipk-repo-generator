#!/bin/bash

# Function to extract control file from IPK
extract_control_from_ipk() {
    ipk_file=$1
    output_file=$2
    filename=$(basename "$ipk_file")

    echo "Extracting control file from $ipk_file..."

    # Decompress the IPK file (gzip compressed)
    gzip -d -c "$ipk_file" > temp.tar
    if [ $? -ne 0 ]; then
        echo "Error: Failed to decompress $ipk_file"
        exit 1
    fi

    # Extract control.tar.gz from the tar archive
    tar --strip-components=1 -xf temp.tar ./control.tar.gz
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract control.tar.gz from $ipk_file"
        rm temp.tar
        exit 1
    fi

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

# Main script
repo_dir="./repo/IPK_files"
packages_file="./output/Packages"

echo "Generating Packages file..."
> "$packages_file" # Empty the file

find "$repo_dir" -type f -name '*.ipk' | while read -r ipk; do
    echo "Processing IPK file: $ipk"
    extract_control_from_ipk "$ipk" "$packages_file"
done

echo "Packages file generated at $packages_file"
