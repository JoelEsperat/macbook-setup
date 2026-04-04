#!/bin/bash

# This script compresses all .jpg files in a specified directory and its subdirectories using mozjpeg's cjpeg tool.
# It processes files in parallel to speed up the compression.

# Check if the directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [quality]"
  exit 1
fi

# Define the directory to search for .jpg files
directory="$1"

# Define the quality (default to 75 if not provided)
quality="${2:-75}"

# Get the total number of files to process
total_files=$(find "$directory" -type f -iname '*.jpg' | wc -l)

# Create a temporary file to store the counter
counter_file=$(mktemp)
echo 0 > "$counter_file"

# Create a lock file
lock_file=$(mktemp)

# Define the function to process each file
process_file() {
  local file="$1"
  local output_dir="$quality/$(dirname -- "$file")"
  mkdir -p "$output_dir"
  /opt/homebrew/opt/mozjpeg/bin/cjpeg -quality "$quality" -outfile "$output_dir/$(basename -- "$file")" "$file"
  
  # Update the counter atomically using a lock file
  while ! shlock -f "$lock_file" -p $$; do
    sleep 0.1
  done
  local counter
  counter=$(($(cat "$counter_file") + 1))
  echo "$counter" > "$counter_file"
  printf "\rProcessed $counter of $total_files files."
  rm -f "$lock_file"
}

export -f process_file
export counter_file
export total_files
export lock_file
export quality

# Find all .jpg files and process them in parallel
find "$directory" -type f -iname '*.jpg' -print0 | xargs -0 -P 12 -n 1 -I {} bash -c 'process_file "$@"' _ {}

# Clean up the temporary files
rm "$counter_file"
