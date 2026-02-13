#!/bin/bash

R2_BUCKET_NAME="braichevsky-konspect-bmp-files"
SOURCE_BMP_DIR="source_bmps"

# Ensure wrangler is installed and authenticated
if ! command -v wrangler &> /dev/null
then
    echo "Error: wrangler CLI not found. Please install it using 'npm install -g wrangler'."
    exit 1
fi

echo "Uploading BMP files from $SOURCE_BMP_DIR to R2 bucket: $R2_BUCKET_NAME"

# Check if the source directory exists
if [ ! -d "$SOURCE_BMP_DIR" ]; then
    echo "Error: Source directory '$SOURCE_BMP_DIR' not found."
    echo "Please ensure your BMP files are in the '$SOURCE_BMP_DIR' directory."
    exit 1
fi

# Loop through each file in the source directory and upload it
for file_path in "$SOURCE_BMP_DIR"/*; do
    if [ -f "$file_path" ]; then
        file_name=$(basename "$file_path")
        echo "Uploading $file_name..."
        # Corrected syntax: Added --remote flag to target the actual Cloudflare R2 service
        wrangler r2 object put "$R2_BUCKET_NAME/$file_name" --file "$file_path" --remote
        if [ $? -ne 0 ]; then
            echo "Error uploading $file_name. Aborting."
            exit 1
        fi
    fi
done

echo "Upload process completed. Your files should now be in the R2 bucket: $R2_BUCKET_NAME"
echo "You can check your Cloudflare R2 dashboard to verify. Ensure your bucket's public access is configured."
