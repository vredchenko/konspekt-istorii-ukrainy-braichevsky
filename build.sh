#!/bin/sh

BUILD_DIR="build"
BOOK_MD="book.md"

# Ensure Pandoc is installed
if ! command -v pandoc > /dev/null 2>&1; then
    echo "Pandoc not found. Please install it using ./tools/install_tools.sh"
    exit 1
fi

# Ensure output directory exists
mkdir -p "$BUILD_DIR"

echo "Building book from $BOOK_MD..."

# 1. Generate HTML
echo "Generating HTML ($BUILD_DIR/book.html)..."
pandoc "$BOOK_MD" -o "$BUILD_DIR/book.html" \
    --standalone \
    --embed-resources \
    --toc \
    --self-contained \
    --css=./tools/styles.css \
    --metadata title="Конспект історії України" \
    --metadata author="Михайло Брайчевський" \
    --metadata date="1993"

# 2. Generate PDF
echo "Generating PDF ($BUILD_DIR/book.pdf)..."
# Requires LaTeX to be installed (e.g., texlive-full)
pandoc "$BOOK_MD" -o "$BUILD_DIR/book.pdf" \
    --toc \
    --pdf-engine=xelatex \
    --metadata title="Конспект історії України" \
    --metadata author="Михайло Брайчевський" \
    --metadata date="1993" \
    -V mainfont="DejaVu Serif" \
    -V sansfont="DejaVu Sans" \
    -V monofont="DejaVu Sans Mono" \
    -V documentclass=article \
    -V geometry:margin=1in \
    -V lang=uk-UA

# 3. Generate EPUB
echo "Generating EPUB ($BUILD_DIR/book.epub)..."
pandoc "$BOOK_MD" -o "$BUILD_DIR/book.epub" \
    --toc \
    --metadata title="Конспект історії України" \
    --metadata author="Михайло Брайчевський" \
    --metadata date="1993" \
    --epub-cover-image=./tools/cover.png

# 4. Generate DOCX
echo "Generating DOCX ($BUILD_DIR/book.docx)..."
pandoc "$BOOK_MD" -o "$BUILD_DIR/book.docx" \
    --toc \
    --metadata title="Конспект історії України" \
    --metadata author="Михайло Брайчевський" \
    --metadata date="1993"

echo "Build process complete. Output files are in the '$BUILD_DIR' directory."
