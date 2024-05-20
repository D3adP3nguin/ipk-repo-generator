#!/bin/bash

packages_file="./output/Packages"
manifest_file="./output/Packages.manifest"

md5sum "$packages_file" > "$manifest_file"
echo "Packages.manifest file generated at $manifest_file"
