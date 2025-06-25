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

# the basename keyword extracts the filename from the path, e.g "content/raw/epub/mybook.epub" becomes "mybook.epub"
# The '|' operator is used to pipe the output of basename to sed
# # The sed command removes the file extension from the filename, by searching for the last '.' and everything after it
BASENAME="$(basename "$FILE_PATH" | sed 's/\.[^.]*$//')"

## Remove the 'content/raw/' prefix from FILE_PATH, if present
RELATIVE_PATH_NO_EXT="${FILE_PATH#content/raw/}"

## Remove the file extension from the end of the path
RELATIVE_PATH_NO_EXT="${RELATIVE_PATH_NO_EXT%.*}"

## Combine COMPLETE_DIR and the relative path (with no extension) using '/'
COMPLETE_PATH="$COMPLETE_DIR/$RELATIVE_PATH_NO_EXT"


EPUB_FILE="$EPUB_DIR/$BASENAME.epub"

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
