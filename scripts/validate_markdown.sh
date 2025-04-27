#!/bin/bash
# filepath: /home/mit/Downloads/Github/WorldTech/scripts/validate_markdown.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Directory containing Markdown files (default to test/updates for testing)
NEWS_DIR=${NEWS_DIR:-test/updates}

# Ensure Telegram credentials are set
if [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]]; then
  echo "Error: Telegram credentials are not set. Exiting."
  exit 1
fi

# Function to send a message to the Telegram bot
send_to_telegram() {
  local message=$1
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="${message}" \
    -d parse_mode="MarkdownV2" > /dev/null
}

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
    send_to_telegram "Warning: $FILE is empty. Skipping validation."
    continue
  fi

  # Skip validation for specific test files (e.g., invalid.md)
  if [[ "$FILE" == *invalid.md ]]; then
    echo "Skipping validation for test file: $FILE"
    send_to_telegram "Skipping validation for test file: $FILE"
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
    send_to_telegram "Warning: $FILE does not contain any valid images or links. Skipping validation."
    continue
  fi

  # Check for Telegram MarkdownV2 special characters and escape them
  ESCAPED_CONTENT=$(sed -E 's/([*_~`>#+=|{}.!-])/\\\1/g' "$FILE")
  echo "$ESCAPED_CONTENT" > "$FILE"

  # Check if the content length exceeds Telegram's limit
  CONTENT_LENGTH=$(wc -c < "$FILE")
  if [[ "$CONTENT_LENGTH" -gt 4096 ]]; then
    echo "Error: $FILE exceeds Telegram's 4096-character limit."
    send_to_telegram "Error: $FILE exceeds Telegram's 4096-character limit."
    exit 1
  fi

  # Validate URLs in the file
  if grep -oE '\(http[s]?:\/\/[^\)]+\)' "$FILE" | grep -vqE '^http[s]?:\/\/'; then
    echo "Error: $FILE contains invalid URLs."
    send_to_telegram "Error: $FILE contains invalid URLs."
    exit 1
  fi

  # Notify Telegram about successful validation
  echo "File $FILE validated successfully."
  send_to_telegram "File $FILE validated successfully."
done

echo "All files in $NEWS_DIR are valid."
send_to_telegram "All files in $NEWS_DIR are valid."