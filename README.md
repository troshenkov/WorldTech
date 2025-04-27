# WorldTech Telegram Automation

![Build Status](https://github.com/troshenkov/WorldTech/actions/workflows/post_to_tg_channel.yml/badge.svg)
![Self-Test Workflow](https://github.com/troshenkov/WorldTech/actions/workflows/self_test.yml/badge.svg)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

## Overview
This project automates the process of posting Markdown news files to a Telegram channel using GitHub Actions. It validates input data, processes Markdown files, and archives processed files for future reference. The project also includes a self-test workflow to validate the functionality of the scripts in a dry run mode.

---

## Features
- **Automated Posting**:
  - Posts Markdown files to a Telegram channel.
  - Supports images, documents, and text content.
- **Validation**:
  - Validates Markdown files according to Telegram MarkdownV2 requirements.
  - Ensures input data is properly formatted and meets Telegram's constraints.
- **Dry Run Mode**:
  - Simulates the process without sending messages to Telegram.
- **Logging and Archiving**:
  - Logs all actions for debugging.
  - Archives processed files to avoid reposting.
- **Customizable**:
  - Supports environment variables for dynamic configuration.
- **Modular Design**:
  - Delegates tasks like secret validation and Markdown processing to external scripts for maintainability.

---

## Workflows

### **Main Workflow**
The main workflow is defined in `.github/workflows/post_to_tg_channel.yml` and includes the following steps:
1. **Checkout Repository**:
   - Clones the repository to the GitHub Actions runner.
2. **Validate Secrets**:
   - Uses `scripts/validate_secrets.sh` to ensure `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` are set.
3. **Process Markdown Files**:
   - Uses `scripts/process_markdown_files.sh` to:
     - Read files from the `updates/` directory.
     - Send images, documents, and text content to Telegram.
     - Archive processed files in the `posted/` directory.
4. **Upload Logs**:
   - Saves detailed logs as GitHub Actions artifacts for debugging.
5. **Commit and Push Changes**:
   - Uses `scripts/git_setup.sh` to configure Git and commit archived files and logs back to the repository.

### **Self-Test Workflow**
The self-test workflow is defined in `.github/workflows/self_test.yml` and performs the following steps:
1. **Checkout Repository**:
   - Clones the repository to the GitHub Actions runner.
2. **Set Up Environment**:
   - Sets up fake environment variables for testing.
3. **Create Test Environment**:
   - Creates an isolated test environment with directories for updates, logs, and posted files.
4. **Generate Test Markdown Files**:
   - Creates various test cases, including:
     - Valid Markdown files.
     - Empty files.
     - Invalid Markdown files.
     - Files with special characters.
     - A batch of 50 Markdown files.
5. **Validate Markdown Files**:
   - Uses `scripts/validate_markdown.sh` to validate test Markdown files according to Telegram requirements.
6. **Run Markdown Processing Script (Dry Run)**:
   - Executes `scripts/process_markdown_files.sh` in dry run mode to simulate processing.
7. **Verify Output**:
   - Ensures processed files are archived and logs are generated.
8. **Upload Logs**:
   - Uploads logs as GitHub Actions artifacts for debugging.
9. **Cleanup**:
   - Cleans up the test environment after the workflow completes.

---

## Directory Structure
```text
WorldTech/
├── updates/                # Input directory for Markdown files
├── posted/                 # Directory for archived files
├── logs/                   # Directory for log files
├── scripts/
│   ├── validate_secrets.sh # Validates required secrets
│   ├── process_markdown_files.sh # Processes Markdown files
│   ├── validate_markdown.sh # Validates Markdown files
│   ├── git_setup.sh        # Configures Git
├── .github/
│   ├── workflows/
│   │   ├── post_to_tg_channel.yml  # Main workflow
│   │   ├── self_test.yml          # Self-test workflow
├── README.md               # Project documentation
├── LICENSE                 # License information
```
---

## Getting Started

### Prerequisites
- A Telegram bot token (`TELEGRAM_BOT_TOKEN`).
- The chat ID of the target Telegram channel (`TELEGRAM_CHAT_ID`).



---
