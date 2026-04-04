#/bin/zsh

# Directory containing photos
PHOTO_DIR="/Users/joel/Downloads/photos"

# Output CSV file
OUTPUT_CSV="/Users/joel/Downloads/photo_catalog.csv"

# Write the header to the CSV file
echo "File,DateTime,Camera,Lens,FocalLengthIn35mmFormat" > "$OUTPUT_CSV"

# List all photos in the directory recursively and export to CSV
total_files=$(find "$PHOTO_DIR" -type f -name "*.jpg" | wc -l)
current_file=0

for file in $PHOTO_DIR/**/**/*.jpg; do
    current_file=$((current_file + 1))
    progress=$((current_file * 100 / total_files))
    printf "\rProgress: %d%%" "$progress"

    exif_data=$(/opt/homebrew/bin/exiftool -s3 -Model -LensModel -FocalLengthIn35mmFormat -s3 -DateTimeOriginal "$file")
    camera_model=$(echo "$exif_data" | sed -n '1p')
    lens_model=$(echo "$exif_data" | sed -n '2p')
    focal_length=$(echo "$exif_data" | sed -n '3p')
    date_taken=$(echo "$exif_data" | sed -n '4p')
    echo "$file,$date_taken,$camera_model,$lens_model,$focal_length" >> "$OUTPUT_CSV"
done

echo -e "\n Cataloging done."
