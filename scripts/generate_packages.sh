#!/bin/bash

# Hardcoded paths
OUTPUT_DIR="./output"
USIGN_PATH="./output/usign"

# Ensure necessary directories exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$USIGN_PATH")"

# Function to extract control file from IPK
extract_control_from_ipk() {
    ipk_file=$1
    output_file=$2
    category=$3
    filename=$(basename "$ipk_file")

    echo "Processing IPK file: $ipk_file"

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
    control_file=$(mktemp)
    tar -xzOf control.tar.gz ./control > "$control_file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract control file from control.tar.gz"
        rm temp.tar control.tar.gz
        exit 1
    fi

    # Add the tag to the Description field
    if [ "$category" == "curated" ]; then
        tag="[Linksys curated]"
    elif [ "$category" == "supported" ]; then
        tag="[Linksys supported]"
    else
        tag=""
    fi

    if [ -n "$tag" ]; then
        sed -i "s/^Description:/Description: $tag /" "$control_file"
    fi

    cat "$control_file" >> "$output_file"

    # Add Filename field
    echo "Filename: $filename" >> "$output_file"

    # Cleanup temporary files
    rm temp.tar control.tar.gz "$control_file"
    echo "" >> "$output_file" # Add an empty line between entries
}

# Function to generate Packages file
generate_packages() {
    ipk_dir=$1
    output_file=$2
    category=$3

    > "$output_file" # Empty the file

    echo "Looking for IPK files in directory: $ipk_dir"

    find "$ipk_dir" -type f -name '*.ipk' | while read -r ipk; do
        extract_control_from_ipk "$ipk" "$output_file" "$category"
    done

    echo "Packages file generated at $output_file"
}

# Main script
ipk_dir="./output"
packages_file="$OUTPUT_DIR/Packages"
category=$1

generate_packages "$ipk_dir" "$packages_file" "$category"

# Verify the Packages file is not empty
if [ ! -s "$packages_file" ]; then
    echo "Error: Packages file is empty or does not exist."
    exit 1
fi
