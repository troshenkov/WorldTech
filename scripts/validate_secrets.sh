#!/bin/bash

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