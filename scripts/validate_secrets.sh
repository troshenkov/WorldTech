#!/bin/bash
# ==================================================================================================
# File: scripts/validate_secrets.sh
#
# Description:
#   This script validates the required secrets for the Telegram workflow. It ensures that the
#   necessary environment variables (`TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`) are set before
#   proceeding with the workflow. If any secret is missing, the script exits with an error.
#
# Usage:
#   This script is called by GitHub Actions workflows to validate secrets before processing
#   Markdown files or posting to Telegram.
#
# Environment Variables:
#   - TELEGRAM_BOT_TOKEN: Telegram Bot API token.
#   - TELEGRAM_CHAT_ID: Target Telegram chat ID.
# ==================================================================================================

# Function to check if a secret is set
check_secret() {
  local secret_name=$1
  local secret_value=$2
  if [ -z "$secret_value" ]; then
    echo "$secret_name is not set. Exiting."
    exit 1
  else
    echo "$secret_name is set."
  fi
}

# Validate required secrets
check_secret "TELEGRAM_BOT_TOKEN" "$TELEGRAM_BOT_TOKEN"
check_secret "TELEGRAM_CHAT_ID" "$TELEGRAM_CHAT_ID"

echo "All required Telegram secrets are validated successfully."