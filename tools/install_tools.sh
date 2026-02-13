#!/bin/bash

# This script installs Pandoc and LaTeX (for PDF generation)
# on Debian/Ubuntu-based systems.

echo "Installing Pandoc..."
sudo apt-get update
sudo apt-get install -y pandoc tesseract-ocr tesseract-ocr-ukr

echo "Installing LaTeX for PDF generation (texlive-full)..."
# texlive-full is comprehensive but large. For a smaller install,
# consider texlive-latex-base, texlive-latex-extra, and latexmk.
sudo apt-get install -y texlive-full

echo "Installation complete. Please verify the installations:"
pandoc --version
pdflatex --version # Check for LaTeX
