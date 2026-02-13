#!/bin/bash

SOURCE_BMP_DIR="source_bmps"
OCR_TEMP_DIR="/home/vredchenko/.gemini/tmp/984539315e1c7b6c123bb891439f320cadc9b7052391990bbf1a884832997f96"
COMBINED_OCR_OUTPUT="$OCR_TEMP_DIR/combined_ocr_output.txt"

# Ensure Tesseract is installed
if ! command -v tesseract &> /dev/null
then
    echo "Tesseract not found. Please install it using ./tools/install_tools.sh"
    exit 1
fi

# Ensure source BMP directory exists
if [ ! -d "$SOURCE_BMP_DIR" ]; then
    echo "Error: Source BMP directory '$SOURCE_BMP_DIR' not found."
    echo "Please place your original BMP files in this directory."
    exit 1
fi

# Clean up previous OCR output
rm -f "$COMBINED_OCR_OUTPUT"
rm -f "$OCR_TEMP_DIR/ocr_LWF*.txt"

echo "Starting OCR process..."

# Loop through each BMP file and perform OCR
for file in "$SOURCE_BMP_DIR"/*.bmp; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        output_base_name="${filename%.*}" # Remove .bmp extension
        output_txt_file="$OCR_TEMP_DIR/ocr_$(basename "$new_filename" .bmp).txt"
        
        echo "OCR'ing $filename to $output_txt_file"
        tesseract "$file" "$OCR_TEMP_DIR/ocr_$(basename "$new_filename" .bmp)" -l ukr || echo "Error OCR'ing $filename"
    fi
done

echo "Combining all OCR'd text files into $COMBINED_OCR_OUTPUT..."
cat "$OCR_TEMP_DIR"/ocr_konspekt-istorii-ukrainy-braichevsky-*.txt > "$COMBINED_OCR_OUTPUT"

echo "OCR process complete. Combined output is in $COMBINED_OCR_OUTPUT"
echo "You can now use this combined output to refine book.md."
