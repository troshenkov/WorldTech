#!/bin/bash

# ==================================================================================================
# Script Name: validate_markdown.sh
#
# Description:
#   This script validates Markdown files in the `updates` folder. It performs the following tasks:
#     - Ensures required directories exist.
#     - Validates Markdown files for required content (e.g., images or links).
#     - Escapes special characters for Telegram MarkdownV2 compatibility.
#     - Checks file size limits for Telegram.
#     - Validates URLs in the Markdown files.
#     - Archives validated files to a specified directory.
#     - Sends notifications to a Telegram bot for warnings, errors, and successful validations.
#
# Usage:
#   ./validate_markdown.sh
#
# Environment Variables:
#   - NEWS_DIR: Directory containing Markdown files (default: updates).
#   - POSTED_DIR: Directory to archive validated files (default: /tmp/markdown_test_tQCI/posted).
#   - LOG_DIR: Directory to store logs (default: /tmp/markdown_test_tQCI/logs).
#   - TELEGRAM_BOT_TOKEN: Telegram bot token for sending notifications.
#   - TELEGRAM_CHAT_ID: Telegram chat ID to send notifications to.
#
# Author: Dmitry Troshenkov <troshenkov.d@gmail.com>
# Last Updated: 2025-04-27
# ==================================================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Configurable directories
NEWS_DIR=${NEWS_DIR:-updates}
POSTED_DIR=${POSTED_DIR:-/tmp/markdown_test_tQCI/posted}
LOG_DIR=${LOG_DIR:-/tmp/markdown_test_tQCI/logs}

# Ensure the posted and log directories exist
mkdir -p "$POSTED_DIR"
mkdir -p "$LOG_DIR"

# Function to send a message to the Telegram bot
send_to_telegram() {
  local message=$1
  if [[ -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
      -d chat_id="${TELEGRAM_CHAT_ID}" \
      -d text="${message}" \
      -d parse_mode="MarkdownV2" > /dev/null || echo "Failed to send Telegram notification."
  else
    echo "Telegram credentials are not set. Skipping Telegram notification."
  fi
}

# Ensure the NEWS_DIR exists (create it if necessary)
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

# Validate each Markdown file in the NEWS_DIR
for FILE in "$NEWS_DIR"/*.md; do
  echo "Validating $FILE..."

  # Check if the file exists and is not empty
  if [[ ! -s "$FILE" ]]; then
    echo "Warning: $FILE is empty. Skipping validation."
    send_to_telegram "Warning: $FILE is empty. Skipping validation."
    continue
  fi

  # Check for required fields (e.g., at least one image or link)
  if ! grep -qE '!\[.*\]\(.*\)|\[.*\]\(.*\)' "$FILE"; then
    echo "Warning: $FILE does not contain any valid images or links. Skipping validation."
    send_to_telegram "Warning: $FILE does not contain any valid images or links. Skipping validation."
    continue
  fi

  # Escape special characters for Telegram MarkdownV2
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

  # Archive the validated file
  ARCHIVED_FILE="$POSTED_DIR/$(date +'%Y-%m-%d')_$(basename "$FILE")"
  cp "$FILE" "$ARCHIVED_FILE"
  echo "Archived $FILE to $ARCHIVED_FILE"

  # Notify Telegram about successful validation
  echo "File $FILE validated successfully."
  send_to_telegram "File $FILE validated successfully."
done

# Notify Telegram about successful validation of all files
echo "All files in $NEWS_DIR are valid."
send_to_telegram "All files in $NEWS_DIR are valid."