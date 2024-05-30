#!/bin/bash

# Read environment variables from GitHub Actions
artifacts_dir="./artifacts"
bucket_name="wrtrepo-out-test"
aws_region="${AWS_REGION}"
aws_access_key_id="${AWS_ACCESS_KEY_ID}"
aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"

# Configure AWS CLI with the provided credentials
aws configure set aws_access_key_id "$aws_access_key_id"
aws configure set aws_secret_access_key "$aws_secret_access_key"
aws configure set region "$aws_region"

# Organize and upload artifacts to S3 without the category in the path
for artifact in "$artifacts_dir"/*; do
    base_dir=$(basename "$artifact" | sed -E 's/-curated--|-supported--//') # Remove category from directory name
    dest_path="s3://$bucket_name/$base_dir"
    echo "Uploading $artifact to $dest_path"
    aws s3 cp "$artifact" "$dest_path" --recursive --sse AES256
    if [ $? -ne 0 ]; then
        echo "Error: Failed to upload $artifact to $dest_path"
        exit 1
    fi
done

echo "All artifacts uploaded to S3 bucket $bucket_name successfully."
