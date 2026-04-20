#!/bin/bash
set -euo pipefail

# This script compresses all .jpg files in a specified directory and its subdirectories using mozjpeg's cjpeg tool.

# Check if the directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [quality]"
  exit 1
fi

# Define the directory to search for .jpg files
directory="$1"

# Define the quality (default to 75 if not provided)
quality="${2:-75}"

cd "$directory"

# Find all .jpg files and process them safely, preserving the directory layout.
find . -type f -iname '*.jpg' -print0 |
  while IFS= read -r -d '' file; do
    rel="${file#./}"
    output_dir="$quality/$(dirname -- "$rel")"
    mkdir -p "$output_dir"
    /opt/homebrew/opt/mozjpeg/bin/cjpeg -quality "$quality" -outfile "$output_dir/$(basename -- "$rel")" "$file"
  done
