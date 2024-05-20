#!/bin/bash

# Hardcoded paths
REPO_DIR="./output"
KEY_DIR="./keys"
USIGN_PATH="./repo/usign/build/usign"

# Ensure necessary directories exist
mkdir -p "$REPO_DIR"
mkdir -p "$(dirname "$USIGN_PATH")"

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

# Function to generate Packages file
generate_packages() {
    repo_dir=$1
    output_file=$2

    echo "Generating Packages file..."
    > "$output_file" # Empty the file

    find "$repo_dir" -type f -name '*.ipk' | while read -r ipk; do
        extract_control_from_ipk "$ipk" "$output_file"
    done

    echo "Packages file generated at $output_file"
}

# Function to generate Packages.gz
generate_packages_gz() {
    packages_file=$1
    gzip -c "$packages_file" > "$packages_file.gz"
    echo "Packages.gz file generated at $packages_file.gz"
}

# Function to generate Packages.manifest
generate_packages_manifest() {
    packages_file=$1
    manifest_file=$2

    echo "Generating Packages.manifest file..."
    md5sum "$packages_file" > "$manifest_file"
    echo "Packages.manifest file generated at $manifest_file"
}

# Main script
packages_file="$REPO_DIR/Packages"
packages_manifest_file="$REPO_DIR/Packages.manifest"
packages_sig_file="$REPO_DIR/Packages.sig"

generate_packages "./repo/IPK_files" "$packages_file"
generate_packages_gz "$packages_file"
generate_packages_manifest "$packages_file" "$packages_manifest_file"

# Call the signing script
chmod +x ./scripts/sign_packages.sh
./scripts/sign_packages.sh "$packages_file" "$packages_sig_file" "$KEY_DIR/openWrtUsign.key" "$USIGN_PATH"

echo "Repository files have been generated and signed in $REPO_DIR"
