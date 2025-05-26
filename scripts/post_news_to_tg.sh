#!/usr/bin/env bash
# filepath: scripts/post_news_to_tg.sh
#
# -----------------------------------------------------------------------------
# Post News to Telegram Channel from Markdown Files
#
# This script scans for Markdown (.md) files in the topics/ directory and posts
# their content to a Telegram channel using the Telegram Bot API.
#
# Usage:
#   - Set TG_BOT_TOKEN and TG_CHAT_ID as environment variables (secrets in CI).
#   - Run this script manually or from a CI workflow.
#
# Features:
#   - Detects changed .md files on push events, or all .md files on manual runs.
#   - Skips empty or oversized files (>4096 characters).
#   - Prevents duplicate posts by tracking posted files in .posted_news.
#   - Reports success or failure for each file.
#   - Logs all actions to scripts/post_news_to_tg.log.
#
# Environment Variables:
#   TG_BOT_TOKEN : Telegram bot token (required)
#   TG_CHAT_ID   : Telegram chat/channel ID (required)
#   GITHUB_EVENT_NAME : Used to distinguish between push/manual runs (optional)
#
# Author: [Your Name]
# -----------------------------------------------------------------------------

set -euo pipefail

NEWS_DIR="topics"
MAX_LEN=4096
POSTED_TRACKER=".posted_news"
LOG_FILE="scripts/post_news_to_tg.log"

# --- Logging function ---
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# --- Check required environment variables ---
if [[ -z "${TG_BOT_TOKEN:-}" || -z "${TG_CHAT_ID:-}" ]]; then
  log "Error: TG_BOT_TOKEN and TG_CHAT_ID must be set in environment."
  exit 1
fi

# --- Prepare posted tracker file ---
touch "$POSTED_TRACKER"

# --- Determine which Markdown files to post ---
if [[ "${GITHUB_EVENT_NAME:-}" == "push" ]]; then
  # On push: only changed .md files in the last commit
  CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD | grep "^${NEWS_DIR}/.*\.md$" || true)
else
  # On manual or other runs: all .md files in topics/
  CHANGED_FILES=$(find "$NEWS_DIR" -maxdepth 1 -type f -name "*.md")
fi

if [[ -z "$CHANGED_FILES" ]]; then
  log "No Markdown news files to post."
  exit 0
fi

# --- Process each Markdown file ---
for file in $CHANGED_FILES; do
  fname=$(basename "$file")

  # --- Prevent duplicate posts ---
  if grep -Fxq "$fname" "$POSTED_TRACKER"; then
    log "Skipping $file (already posted)."
    continue
  fi

  log "Processing $file..."

  # --- Check file existence ---
  if [[ ! -f "$file" ]]; then
    log "File $file does not exist, skipping."
    continue
  fi

  # --- Check file is not empty ---
  char_num=$(wc -c < "$file")
  if (( char_num == 0 )); then
    log "File $file is empty, skipping."
    continue
  fi

  # --- Check file size limit ---
  if (( char_num > MAX_LEN )); then
    log "File $file is too large ($char_num chars), skipping."
    continue
  fi

  # --- Post file content to Telegram ---
  resp=$(curl -s -X POST \
    -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
    "https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TG_CHAT_ID}" \
    -d parse_mode=Markdown \
    --data-urlencode text@"$file")

  # --- Check Telegram API response ---
  ok=$(echo "$resp" | grep -o '"ok":true' || true)
  if [[ -n "$ok" ]]; then
    log "Posted $file successfully."
    echo "$fname" >> "$POSTED_TRACKER"
  else
    log "Failed to post $file. Response: $resp"
  fi
done

log "All done."
# --- End of script ---