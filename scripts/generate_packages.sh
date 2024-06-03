#!/bin/bash

# Function to extract the control file from an IPK package and append it to the output file
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

    # Add the appropriate tag to the Description field based on the category
    if [ "$category" == "curated" ]; then
        tag="[Linksys Curated]"
    elif [ "$category" == "supported" ]; then
        tag="[Linksys Supported]"
    else
        tag=""
    fi

    if [ -n "$tag" ]; then
        sed -i "s/^Description:/Description: $tag /" "$control_file"
    fi

    # Append the control file contents to the output file
    cat "$control_file" >> "$output_file"

    # Add the Filename field to the output file
    echo "Filename: $filename" >> "$output_file"

    # Clean up temporary files
    rm temp.tar control.tar.gz "$control_file"
    echo "" >> "$output_file" # Add an empty line between entries
}

# Function to generate the Packages file by processing each IPK package in the directory
generate_packages() {
    ipk_dir=$1
    output_file=$2
    category=$3

    > "$output_file" # Empty the file before appending new data

    echo "Looking for IPK files in directory: $ipk_dir"

    # Find all IPK files in the directory and process each one
    find "$ipk_dir" -type f -name '*.ipk' | while read -r ipk; do
        extract_control_from_ipk "$ipk" "$output_file" "$category"
    done

    echo "Packages file generated at $output_file"
}

# Main script execution
device=$1
fw=$2
flavor=$3
category=$4
ipk_dir="./output/${device}/${fw}/${flavor}/${category}"
packages_file="${ipk_dir}/Packages"

generate_packages "$ipk_dir" "$packages_file" "$category"

# Verify that the Packages file is not empty
if [ ! -s "$packages_file" ]; then
    echo "Error: Packages file is empty or does not exist."
    exit 1
fi
