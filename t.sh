#!/bin/bash

#!/bin/bash

# Get the last commit hash
commit=$(git log -1 --pretty=format:"%H")

# Get the list of files changed in the last commit
files_changed=$(git diff-tree --no-commit-id --name-only -r ${commit} | head -n 1 | grep  ".md")

# Get the last file changed
last_file=$(echo "$files_changed" | tail -n 1)

# Print the raw content of the last file changed
#msg=$(git show $commit:$last_file)
#curl -s -X POST https://api.telegram.org/bot7046871817:AAGQhK0pC8LeyYEdBQJ6ikokqM9suvByJ-U/sendMessage -d chat_id=-1002094642696  -d parse_mode="Markdown" -d text="${msg}"

curl -s -X POST https://api.telegram.org/bot7046871817:AAGQhK0pC8LeyYEdBQJ6ikokqM9suvByJ-U/sendMessage -d chat_id=-1002094642696  -d parse_mode=Markdown --data-urlencode text@${last_file}

