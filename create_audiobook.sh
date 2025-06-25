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

# Find the file in content/raw (recursively, but not in epub)
MATCHES=( $(find "$RAW_DIR" -type f -not -path "$EPUB_DIR/*" -name "$(basename "$INPUT_FILE")") )

if [[ ${#MATCHES[@]} -eq 0 ]]; then
  echo "Error: File '$INPUT_FILE' not found in $RAW_DIR."
  exit 1
elif [[ ${#MATCHES[@]} -gt 1 ]]; then
  echo "Error: Multiple files named '$(basename "$INPUT_FILE")' found in $RAW_DIR."
  exit 1
fi

FILE_PATH="${MATCHES[0]}"
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
