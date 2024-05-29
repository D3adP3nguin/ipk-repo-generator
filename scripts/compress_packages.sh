#!/bin/bash

# Function to generate Packages.gz
generate_packages_gz() {
    packages_file=$1
    gzip -c "$packages_file" > "$packages_file.gz"
    echo "Packages.gz file generated at $packages_file.gz"
}

# Main script
packages_file="./output/Packages"

generate_packages_gz "$packages_file"
