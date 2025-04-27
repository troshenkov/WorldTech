#!/bin/bash
# filepath: /home/mit/Downloads/Github/WorldTech/scripts/validate_markdown.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Directory containing Markdown files
NEWS_DIR=${NEWS_DIR:-updates}

# Check if the directory exists
if [ ! -d "$NEWS_DIR" ]; then
  echo "Error: Directory $NEWS_DIR does not exist."
  exit 1
fi

# Validate each Markdown file
for FILE in "$NEWS_DIR"/*.md; do
  echo "Validating $FILE..."

  # Check if the file exists and is not empty
  if [ ! -s "$FILE" ]; then
    echo "Error: $FILE is empty or does not exist."
    exit 1
  fi

  # Check for required fields (e.g., at least one image or link)
  if ! grep -qE '!\[.*\]\(.*\)|\[.*\]\(.*\)' "$FILE"; then
    echo "Error: $FILE does not contain any valid images or links."
    exit 1
  fi

  # Check for Telegram MarkdownV2 special characters and escape them
  ESCAPED_CONTENT=$(sed -E 's/([*_~`>#+\-=|{}.!])/\\\1/g' "$FILE")
  echo "$ESCAPED_CONTENT" > "$FILE"

  # Check if the content length exceeds Telegram's limit
  CONTENT_LENGTH=$(wc -c < "$FILE")
  if [ "$CONTENT_LENGTH" -gt 4096]; then
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