# WorldTech Telegram Automation

## Overview
This project automates the process of posting Markdown news files to a Telegram channel using GitHub Actions. The workflow (`post_to_tg_channel.yml`) processes files from the `updates/` directory, sends content to Telegram, and archives processed files in the `posted/` directory.

---

## Features
- **Automated Posting**:
  - Posts Markdown files to a Telegram channel.
  - Supports images, documents, and text content.
- **Error Handling**:
  - Retries failed Telegram API calls and logs errors for debugging.
- **MarkdownV2 Support**:
  - Escapes special characters for Telegram MarkdownV2 formatting.
- **File Archiving**:
  - Archives processed files to avoid reposting.
- **Inline Buttons**:
  - Adds dynamic inline buttons (e.g., "Read More" links) to posts.
- **Logging**:
  - Logs all actions and uploads logs as GitHub Actions artifacts.
- **Customizable**:
  - Supports environment variables for dynamic configuration.

---

## Workflow
The workflow is defined in `.github/workflows/post_to_tg_channel.yml` and includes the following steps:
1. **Validate Secrets**:
   - Ensures `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` are set.
2. **Process Markdown Files**:
   - Reads files from the `updates/` directory.
   - Sends images, documents, and text content to Telegram.
   - Archives processed files in the `posted/` directory.
3. **Upload Logs**:
   - Saves detailed logs as GitHub Actions artifacts.
4. **Commit Changes**:
   - Commits and pushes archived files and logs to the repository.

---

## Directory Structure
WorldTech/
├── updates/                # Input directory for Markdown files to be posted
├── posted/                 # Directory for archived files after processing
├── logs/                   # Directory for log files generated during the workflow
├── .github/
│   ├── workflows/
│   │   ├── post_to_tg_channel.yml  # GitHub Actions workflow definition
│   │   ├── ROADMAP.md             # Roadmap for planned improvements
├── README.md               # Project documentation
├── LICENSE                 # License information for the project

---

## Getting Started

### Prerequisites
- A Telegram bot token (`TELEGRAM_BOT_TOKEN`).
- The chat ID of the target Telegram channel (`TELEGRAM_CHAT_ID`).

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/WorldTech.git
   cd WorldTech
