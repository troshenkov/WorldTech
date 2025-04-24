#!/bin/bash

# Define the ensure_directory function
ensure_directory() {
  local dir_name=$1
  mkdir -p "$dir_name"
  if [ -d "$dir_name" ]; then
    echo "Directory '$dir_name' is ready."
  else
    echo "Failed to create directory '$dir_name'. Exiting."
    exit 1
  fi
}

# Define the send_image function
send_image() {
  local image_url=$1
  echo "Sending image: $image_url" >> "$LOG_DIR/telegram.log"
  RESP=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendPhoto" \
    -d chat_id="$TELEGRAM_CHAT_ID" -d photo="$image_url")
  echo "$RESP" >> "$LOG_DIR/telegram.log"
  echo "$RESP" | grep -q '"ok":true' || {
    echo "Failed to send image: $image_url" >> "$LOG_DIR/telegram.log"
    return 1
  }
}

# Define the send_document function
send_document() {
  local document_url=$1
  echo "Sending document: $document_url" >> "$LOG_DIR/telegram.log"
  RESP=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" \
    -d chat_id="$TELEGRAM_CHAT_ID" -d document="$document_url")
  echo "$RESP" >> "$LOG_DIR/telegram.log"
  echo "$RESP" | grep -q '"ok":true' || {
    echo "Failed to send document: $document_url" >> "$LOG_DIR/telegram.log"
    return 1
  }
}

# Define the send_text_chunk function
send_text_chunk() {
  local chunk=$1
  echo "Sending text chunk:" >> "$LOG_DIR/telegram.log"
  echo "$chunk" >> "$LOG_DIR/telegram.log"
  RESP=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" -d parse_mode="MarkdownV2" --data-urlencode text="$chunk")
  echo "$RESP" >> "$LOG_DIR/telegram.log"
  echo "$RESP" | grep -q '"ok":true' || {
    echo "Failed to send text chunk." >> "$LOG_DIR/telegram.log"
    return 1
  }
}

# Define the send_buttons function
send_buttons() {
  local buttons=$1
  echo "Sending inline buttons." >> "$LOG_DIR/telegram.log"
  RESP=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" -d parse_mode="MarkdownV2" \
    --data-urlencode text="See more" -d "reply_markup=$buttons")
  echo "$RESP" >> "$LOG_DIR/telegram.log"
  echo "$RESP" | grep -q '"ok":true' || {
    echo "Failed to send buttons." >> "$LOG_DIR/telegram.log"
    return 1
  }
}

# Define directories for news files and processed files
NEWS_DIR="updates"
POSTED_DIR="posted"
LOG_DIR="logs"

# Ensure required directories exist
ensure_directory "$NEWS_DIR"
ensure_directory "$POSTED_DIR"
ensure_directory "$LOG_DIR"

# Find all Markdown files in the updates directory
FILES=$(find "$NEWS_DIR" -type f -name '*.md')

# Exit if no Markdown files are found
[ -z "$FILES" ] && echo "No Markdown files to post." && exit 0

# Loop through each Markdown file
for FILE in $FILES; do
  LOG_FILE="$LOG_DIR/$(basename "$FILE" .md).log"
  echo "Processing file: $FILE" >> "$LOG_FILE"

  # Read the content of the file
  CONTENT=$(cat "$FILE")

  # Skip empty files
  [ -z "$CONTENT" ] && echo "Skipping empty file: $FILE" >> "$LOG_FILE" && continue

  # Extract image URLs from Markdown (![](url))
  IMAGE_URLS=$(grep -oE '!\[[^]]*\]\(([^)]+)\)' "$FILE" | sed -E 's/!\[[^]]*\]\(([^)]+)\)/\1/')
  for IMG in $IMAGE_URLS; do
    send_image "$IMG" || continue
  done

  # Extract document URLs (e.g., PDF, DOC, DOCX, PPTX)
  DOC_PATTERN='https?://[^ )]+\.(pdf|docx?|pptx?)'
  DOCUMENT_URLS=$(grep -oE "$DOC_PATTERN" "$FILE" | sort -u)
  for DOC in $DOCUMENT_URLS; do
    send_document "$DOC" || continue
  done

  # Remove image Markdown syntax from the content for cleaner text
  CLEANED_MSG=$(echo "$CONTENT" | sed -E 's/!\[[^\]]*\]\([^)]*\)//g')

  # Check if there is any text content to send
  if [ -n "$CLEANED_MSG" ]; then
    CHUNK_SIZE=4096
    while [ ${#CLEANED_MSG} -gt 0 ]; do
      CHUNK="${CLEANED_MSG:0:$CHUNK_SIZE}"
      CLEANED_MSG="${CLEANED_MSG:$CHUNK_SIZE}"
      send_text_chunk "$CHUNK" || continue
    done
  fi

  # Send inline buttons (e.g., "Read More" link)
  BUTTONS='{"inline_keyboard":[[{"text":"Read More","url":"http://example.com"}]]}'
  send_buttons "$BUTTONS" || continue

  # Archive the processed file by moving it to the posted directory with a timestamp
  TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
  BASENAME=$(basename "$FILE")
  mv "$FILE" "$POSTED_DIR/${TIMESTAMP}_$BASENAME"
  echo "Finished processing: $FILE" >> "$LOG_FILE"
done