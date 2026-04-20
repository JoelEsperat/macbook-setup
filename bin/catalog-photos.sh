#!/bin/zsh
set -euo pipefail

# Directory containing photos
PHOTO_DIR="$HOME/Downloads/photos"

# Output CSV file
OUTPUT_CSV="$HOME/Downloads/photo_catalog.csv"

# Write the header to the CSV file
echo "File,DateTime,Camera,Lens,FocalLengthIn35mmFormat" > "$OUTPUT_CSV"

# List all photos in the directory recursively and export to CSV
find "$PHOTO_DIR" -type f -iname "*.jpg" -print0 |
  while IFS= read -r -d '' file; do
    exif_data=$(/opt/homebrew/bin/exiftool -s3 -Model -LensModel -FocalLengthIn35mmFormat -s3 -DateTimeOriginal "$file")
    camera_model=$(echo "$exif_data" | sed -n '1p')
    lens_model=$(echo "$exif_data" | sed -n '2p')
    focal_length=$(echo "$exif_data" | sed -n '3p')
    date_taken=$(echo "$exif_data" | sed -n '4p')
    echo "$file,$date_taken,$camera_model,$lens_model,$focal_length" >> "$OUTPUT_CSV"
  done

echo "Cataloging done."
