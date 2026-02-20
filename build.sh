#!/bin/sh
set -e

BUILD_DIR="build"
GH_PAGES_BUILD_DIR="$BUILD_DIR/gh-pages-site"
BOOK_MD="book.md"

# Ensure Pandoc is installed
if ! command -v pandoc > /dev/null 2>&1; then
    echo "Pandoc not found. Please install it using ./tools/install_tools.sh"
    exit 1
fi

# Ensure output directory exists
mkdir -p "$BUILD_DIR"
mkdir -p "$GH_PAGES_BUILD_DIR"

echo "Building book from $BOOK_MD..."

# 1. Generate HTML
echo "Generating HTML ($BUILD_DIR/book.html)..."
pandoc "$BOOK_MD" -o "$BUILD_DIR/book.html" \
    --standalone \
    --embed-resources \
    --toc \
    --self-contained \
    --css=./tools/styles.css \
    --include-before-body=./tools/nav-uk.html \
    --metadata title="Конспект історії України" \
    --metadata author="Михайло Брайчевський" \
    --metadata date="1993"

echo "Generating GitHub Pages HTML (UA) ($GH_PAGES_BUILD_DIR/index.html)..."
pandoc "$BOOK_MD" -o "$GH_PAGES_BUILD_DIR/index.html" \
    --standalone \
    --css=styles/main.css \
    --include-before-body=./website/templates/header-ua.html \
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

# 5. Copy Markdown source for release
echo "Copying Markdown source ($BUILD_DIR/book.md)..."
cp "$BOOK_MD" "$BUILD_DIR/"

# --- English Translation ---
BOOK_EN="book-en.md"

if [ -f "$BOOK_EN" ]; then
  echo ""
  echo "Building English translation from $BOOK_EN..."

  # 5. Generate English HTML
  echo "Generating HTML ($BUILD_DIR/book-en.html)..."
  pandoc "$BOOK_EN" -o "$BUILD_DIR/book-en.html" \
      --standalone \
      --embed-resources \
      --toc \
      --self-contained \
      --css=./tools/styles.css \
      --include-before-body=./tools/nav-en.html \
      --metadata title="An Outline of Ukrainian History" \
      --metadata author="Mykhaylo Braychevsky" \
      --metadata date="1993"

  # 6. Generate English PDF
  echo "Generating PDF ($BUILD_DIR/book-en.pdf)..."
  pandoc "$BOOK_EN" -o "$BUILD_DIR/book-en.pdf" \
      --toc \
      --pdf-engine=xelatex \
      --metadata title="An Outline of Ukrainian History" \
      --metadata author="Mykhaylo Braychevsky" \
      --metadata date="1993" \
      -V mainfont="DejaVu Serif" \
      -V sansfont="DejaVu Sans" \
      -V monofont="DejaVu Sans Mono" \
      -V documentclass=article \
      -V geometry:margin=1in \
      -V lang=en

  # 7. Generate English EPUB
  echo "Generating EPUB ($BUILD_DIR/book-en.epub)..."
  pandoc "$BOOK_EN" -o "$BUILD_DIR/book-en.epub" \
      --toc \
      --metadata title="An Outline of Ukrainian History" \
      --metadata author="Mykhaylo Braychevsky" \
      --metadata date="1993" \
      --epub-cover-image=./tools/cover.png

  # 8. Generate English DOCX
  echo "Generating DOCX ($BUILD_DIR/book-en.docx)..."
  pandoc "$BOOK_EN" -o "$BUILD_DIR/book-en.docx" \
      --toc \
      --metadata title="An Outline of Ukrainian History" \
      --metadata author="Mykhaylo Braychevsky" \
      --metadata date="1993"

  # Copy English Markdown source for release
  echo "Copying Markdown source ($BUILD_DIR/book-en.md)..."
  cp "$BOOK_EN" "$BUILD_DIR/"

  echo "English translation build complete."

  echo ""
  echo "Building GitHub Pages HTML (EN) ($GH_PAGES_BUILD_DIR/en/index.html)..."
  mkdir -p "$GH_PAGES_BUILD_DIR/en"
  pandoc "$BOOK_EN" -o "$GH_PAGES_BUILD_DIR/en/index.html" \
      --standalone \
      --css=../styles/main.css \
      --include-before-body=./website/templates/header-en.html \
      --metadata title="An Outline of Ukrainian History" \
      --metadata author="Mykhaylo Braychevsky" \
      --metadata date="1993"

  echo "Creating GitHub Pages redirect (UA alias) ($GH_PAGES_BUILD_DIR/ua/index.html)..."
  mkdir -p "$GH_PAGES_BUILD_DIR/ua"
    cat > "$GH_PAGES_BUILD_DIR/ua/index.html" <<'REDIRECT'
<!DOCTYPE html>
<html><head><meta http-equiv="refresh" content="0;url=../"></head>
<body><a href="../">Redirect</a></body></html>
REDIRECT
  
    echo "Copying GitHub Pages assets to $GH_PAGES_BUILD_DIR..."
    mkdir -p "$GH_PAGES_BUILD_DIR/styles"
    cp ./website/styles/main.css "$GH_PAGES_BUILD_DIR/styles/"
    # Copy fonts
    cp -r ./website/fonts "$GH_PAGES_BUILD_DIR/"
    # Assuming there might be assets in website/assets, copy them too if they exist
    if [ -d "./website/assets" ]; then
      cp -r ./website/assets "$GH_PAGES_BUILD_DIR/"
    fi
  
  else
    echo "No English translation found ($BOOK_EN), skipping."
  fi
  
  echo "Build process complete. Output files are in the '$BUILD_DIR' directory."
