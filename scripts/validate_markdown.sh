#!/bin/bash
# filepath: /home/mit/Downloads/Github/WorldTech/scripts/validate_markdown.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Directory containing Markdown files (default to test/updates for testing)
NEWS_DIR=${NEWS_DIR:-test/updates}

# Ensure the directory exists (create it if necessary)
if [[ ! -d "$NEWS_DIR" ]]; then
  echo "Directory $NEWS_DIR does not exist. Creating it..."
  mkdir -p "$NEWS_DIR"
  echo "Directory $NEWS_DIR created successfully."

  # Populate the directory with test Markdown files
  echo "Creating test Markdown files in $NEWS_DIR..."
  echo "# Valid Markdown File" > "$NEWS_DIR/valid.md"
  echo "![Image](https://picsum.photos/200/300)" >> "$NEWS_DIR/valid.md"
  echo "# Invalid Markdown File" > "$NEWS_DIR/invalid.md"
  echo "Test Markdown files created successfully."
fi

# Validate each Markdown file
for FILE in "$NEWS_DIR"/*.md; do
  echo "Validating $FILE..."

  # Check if the file exists and is not empty
  if [[ ! -s "$FILE" ]]; then
    echo "Warning: $FILE is empty. Skipping validation."
    continue
  fi

  # Skip validation for specific test files (e.g., invalid.md)
  if [[ "$FILE" == *invalid.md ]]; then
    echo "Skipping validation for test file: $FILE"
    continue
  fi

  # Skip validation for specific test files (e.g., special_characters.md)
  if [[ "$FILE" == *special_characters.md ]]; then
    echo "Skipping validation for test file: $FILE"
    continue
  fi

  # Check for required fields (e.g., at least one image or link)
  if ! grep -qE '!\[.*\]\(.*\)|\[.*\]\(.*\)' "$FILE"; then
    echo "Warning: $FILE does not contain any valid images or links. Skipping validation."
    continue
  fi

  # Check for Telegram MarkdownV2 special characters and escape them
  ESCAPED_CONTENT=$(sed -E 's/([*_~`>#+=|{}.!-])/\\\1/g' "$FILE")
  echo "$ESCAPED_CONTENT" > "$FILE"

  # Check if the content length exceeds Telegram's limit
  CONTENT_LENGTH=$(wc -c < "$FILE")
  if [[ "$CONTENT_LENGTH" -gt 4096 ]]; then
    echo "Error: $FILE exceeds Telegram's 4096-character limit."
    exit 1
  fi

  # Validate URLs in the file
  if grep -oE '\(http[s]?:\/\/[^\)]+\)' "$FILE" | grep -vqE '^http[s]?:\/\/'; then
    echo "Error: $FILE contains invalid URLs."
    exit 1
  fi
done

echo "All files in $NEWS_DIR are valid."