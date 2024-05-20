#!/bin/bash

packages_file="./output/Packages"

gzip -c "$packages_file" > "$packages_file.gz"
echo "Packages.gz file generated at $packages_file.gz"
