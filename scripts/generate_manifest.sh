#!/bin/bash

# Function to generate Packages.manifest by listing files in each IPK package
generate_packages_manifest() {
    ipk_dir=$1
    manifest_file=$2

    > "$manifest_file" # Empty the file before appending new data

    # Find all IPK files in the directory and process each one
    find "$ipk_dir" -type f -name '*.ipk' | while read -r ipk; do
        filename=$(basename "$ipk")
        temp_dir=$(mktemp -d)

        # Extract the data.tar.gz file from the IPK package
        tar -xOf "$ipk" ./data.tar.gz | tar -xz -C "$temp_dir"

        # List the files in the package and add package metadata to the manifest file
        echo "Package: ${filename%.*}" >> "$manifest_file"
        find "$temp_dir" -type f | sed "s|$temp_dir||" >> "$manifest_file"
        echo "" >> "$manifest_file"

        # Clean up the temporary directory
        rm -rf "$temp_dir"
    done

    echo "Packages.manifest file generated at $manifest_file"
}

# Main script execution
device=$1
fw=$2
flavor=$3
category=$4
ipk_dir="./output/${device}/${fw}/${flavor}/${category}"
manifest_file="$ipk_dir/Packages.manifest"

generate_packages_manifest "$ipk_dir" "$manifest_file"
