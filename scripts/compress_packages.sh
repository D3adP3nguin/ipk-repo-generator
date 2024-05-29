#!/bin/bash

# Compress the Packages file
gzip -k -f ./output/Packages

echo "Packages file compressed to Packages.gz"
