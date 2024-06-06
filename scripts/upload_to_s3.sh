#!/bin/bash

# Read environment variables from GitHub Actions
artifacts_dir="./artifacts"
bucket_name="[REDACTED]"
aws_region="${AWS_REGION}"
aws_access_key_id="${AWS_ACCESS_KEY_ID}"
aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"

# Check if the artifacts directory exists
if [ ! -d "$artifacts_dir" ]; then
    echo "Error: Artifacts directory $artifacts_dir does not exist."
    exit 1
fi

# Configure AWS CLI with the provided credentials
aws configure set aws_access_key_id "$aws_access_key_id"
aws configure set aws_secret_access_key "$aws_secret_access_key"
aws configure set region "$aws_region"

# Organize and upload artifacts to S3
for artifact in "$artifacts_dir"/*; do
    dest_path="s3://$bucket_name/${artifact##*/}"
    echo "Uploading $artifact to $dest_path"
    aws s3 cp "$artifact" "$dest_path" --recursive --sse AES256
    if [ $? -ne 0 ]; then
        echo "Error: Failed to upload $artifact to $dest_path"
        exit 1
    fi
done

echo "All artifacts uploaded to S3 bucket $bucket_name successfully."
