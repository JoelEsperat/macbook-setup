#!/bin/zsh
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <photo-directory>"
  exit 1
fi

# Directory containing photos
PHOTO_DIR="$1"

# Output CSV file
OUTPUT_CSV="$PWD/photo_catalog.csv"

# Ensure the output directory exists
mkdir -p "$(dirname "$OUTPUT_CSV")"

# Export EXIF metadata directly to CSV (100x faster, avoids misalignment/corruption, handles commas in file paths)
if [ -d "$PHOTO_DIR" ]; then
  # Ensure exiftool is in the PATH (using Homebrew on Apple Silicon)
  export PATH="/opt/homebrew/bin:$PATH"
  
  # Generate the CSV
  exiftool -csv -DateTimeOriginal -Model -LensModel -FocalLengthIn35mmFormat -ext jpg -ext jpeg -ext JPG -ext JPEG -r "$PHOTO_DIR" > "$OUTPUT_CSV"
  
  # Rename headers to match original layout: SourceFile -> File, DateTimeOriginal -> DateTime, Model -> Camera, LensModel -> Lens
  if [ -f "$OUTPUT_CSV" ]; then
    sed -i '' '1s/SourceFile,DateTimeOriginal,Model,LensModel/File,DateTime,Camera,Lens/' "$OUTPUT_CSV"
  fi
else
  echo "Error: Directory $PHOTO_DIR does not exist."
  exit 1
fi

echo "Cataloging done."
