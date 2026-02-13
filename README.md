# Built with Gemini CLI
![Built with Gemini CLI](https://img.shields.io/badge/Built%20with-Gemini%20CLI-blue)

# Ukraine Short History BMP Conversion

This repository contains the OCR'd text of "Конспект історії України" by Михайло Брайчевський, originally sourced from BMP image files. The goal is to provide a single source Markdown document from which various publishable formats (webpage, PDF, ePub, DOCX) can be generated.

## Development Prerequisites

To work with this project and generate the various output formats, you will need to install the following tools:

*   **Git:** For version control.
*   **Pandoc:** A universal document converter.
*   **LaTeX distribution:** Required by Pandoc for PDF generation.
*   **Tesseract OCR:** For performing OCR on the source BMP files.

### Installation Instructions

You can use the provided `tools/install_tools.sh` script to install Pandoc, LaTeX, and Tesseract on Debian/Ubuntu-based systems. For other operating systems or distributions, please refer to the official documentation for each tool.

1.  **Make the script executable:**
    ```bash
    chmod +x tools/install_tools.sh
    ```
2.  **Run the installation script:**
    ```bash
    ./tools/install_tools.sh
    ```

## Acquiring Source BMPs

The original BMP image files are not stored in this repository due to their size and potential metadata. To fully reproduce the OCR process, you need to:

1.  **Create the `source_bmps/` directory:**
    ```bash
    mkdir source_bmps
    ```
2.  **Place the original BMP files** into this `source_bmps/` directory. For example, `konspekt-istorii-ukrainy-braichevsky-0000.bmp`.

## Parsing (OCR) the BMPs

The OCR process is a separate step that transforms the raw BMP images into text. This step is not part of the main build/publish workflow (which assumes the `book.md` is ready) and is generally only needed if you start from scratch with the BMPs or if you want to re-OCR.

To perform the OCR:

1.  Ensure you have placed the BMPs in the `source_bmps/` directory as described above.
2.  Run the parsing script:
    ```bash
    ./parse.sh
    ```
    This will generate individual OCR text files in a temporary directory and combine them into `combined_ocr_output.txt`.

## Building the Book

Detailed instructions for building the different output formats will be provided here once the build script is created.

## Repository Structure

*   `./source_bmps/`: Original BMP image files (ignored by Git).
*   `./book.md`: The main Markdown source file for the book.
*   `./README.md`: This file.
*   `./tools/install_tools.sh`: Script to install development prerequisites.
*   `./parse.sh`: Script to perform OCR on BMP files and generate `combined_ocr_output.txt` (to be created).
*   `./build.sh`: Script to build various output formats (to be created).
*   `./.github/workflows/publish.yml`: (Optional) GitHub Actions workflow for CI/CD (to be created).
