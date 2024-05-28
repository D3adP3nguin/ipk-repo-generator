#!/bin/bash

find ../devices -type d -mindepth 3 -maxdepth 3 | while read -r path; do
    echo "  - ${path}"
done
