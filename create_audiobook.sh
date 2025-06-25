#!/bin/bash

set -e

usage() {
  echo "Usage: $0 -f <filename>"
  exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -f|--file)
      INPUT_FILE="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z "$INPUT_FILE" ]]; then
  usage
fi

RAW_DIR="content/raw"
EPUB_DIR="$RAW_DIR/epub"
COMPLETE_DIR="content/complete"


# Ensure file is in a subfolder of content/raw (not directly in content/raw or in epub)
if [[ "$INPUT_FILE" == */* ]] && [[ "$INPUT_FILE" != epub/* ]]; then
  FILE_PATH="$INPUT_FILE"
else
  echo "Error: File must be in a subfolder of $RAW_DIR (not directly in $RAW_DIR or in epub/)."
  exit 1
fi

if [[ ! -f "$FILE_PATH" ]]; then
  echo "Error: File '$FILE_PATH' not found."
  exit 1
fi

BASENAME="$(basename "$FILE_PATH" | sed 's/\.[^.]*$//')"
EPUB_FILE="$EPUB_DIR/$BASENAME.epub"
COMPLETE_PATH="$COMPLETE_DIR/$BASENAME"

# Convert to epub if not already in epub dir
if [[ "$FILE_PATH" != "$EPUB_FILE" ]]; then
  mkdir -p "$EPUB_DIR"
  pandoc "$FILE_PATH" -o "$EPUB_FILE"
fi

# Create output directory
mkdir -p "$COMPLETE_PATH"

# Run audiblez
abs_complete_path="$(cd "$COMPLETE_PATH" && pwd)"
audiblez "$EPUB_FILE" -v af_sky -o "$abs_complete_path"
