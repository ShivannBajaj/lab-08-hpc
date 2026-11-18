#!/bin/bash
set -euo pipefail

# Get the bucket name and book directory
BUCKET="$1"
BOOK_DIR="$2"

# Create the directory if it doesn't exist
mkdir -p "$BOOK_DIR"

# Convert the directory to an absolute path
BOOK_DIR=$(realpath "$BOOK_DIR")

# Copy only .txt files from the S3 bucket
aws s3 cp "s3://$BUCKET" "$BOOK_DIR" \
    --recursive \
    --exclude "*" \
    --include "*.txt"

# Create book_list.txt with the header
echo "File path" > book_list.txt

# Find all .txt files and append their sorted absolute paths
find "$BOOK_DIR" -type f -name "*.txt" | sort >> book_list.txt

# Print the number of books (excluding the header)
echo "Number of books listed: $(tail -n +2 book_list.txt | wc -l)"
