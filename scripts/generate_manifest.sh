#!/bin/bash

# Function to generate Packages.manifest
generate_packages_manifest() {
    packages_file=$1
    manifest_file=$2

    echo "Generating Packages.manifest file..."
    md5sum "$packages_file" > "$manifest_file"
    echo "Packages.manifest file generated at $manifest_file"
}

# Main script
packages_file="./output/Packages"
manifest_file="./output/Packages.manifest"

generate_packages_manifest "$packages_file" "$manifest_file"
