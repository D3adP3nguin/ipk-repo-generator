#!/bin/bash

# Organize directories
for artifact in ./artifacts/*; do
  base_name=$(echo $artifact | sed 's/-curated--[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}//;s/-supported--[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}//')
  if [ ! -d "combined/$base_name" ]; then
    mkdir -p "combined/$base_name"
  fi
  cp -r $artifact/* "combined/$base_name/"
done

# Upload to S3
for dir in combined/*; do
  dest_path="s3://wrtrepo-out-test/${dir##*/}"
  echo "Uploading $dir to $dest_path"
  aws s3 cp "$dir" "$dest_path" --recursive --sse AES256
done
