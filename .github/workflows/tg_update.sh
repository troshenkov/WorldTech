#!/bin/bash

# Get the last commit hash
commit=$(git log -1 --pretty=format:"%H")

# Get the list of files changed in the last commit
files_changed=$(git diff-tree --no-commit-id --name-only -r ${commit} | head -n 1 | grep  ".md")

# Get the last file changed
last_file=$(echo "$files_changed" | tail -n 1)

curl -s -X POST https://api.telegram.org/bot${{ secrets.TELEGRAM_BOT_TOKEN }}/sendMessage -d chat_id=${{ secrets.TELEGRAM_CHANNEL_ID }} -d parse_mode=Markdown --data-urlencode text@${last_file}
