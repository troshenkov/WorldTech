# WorldTech Telegram Automation

![Build Status](https://github.com/username/repo/actions/workflows/build.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-green)
![Self-Test Workflow](https://github.com/your-username/your-repo/actions/workflows/self_test.yml/badge.svg)

## Overview
This project automates the process of posting Markdown news files to a Telegram channel using GitHub Actions. The workflow (`post_to_tg_channel.yml`) processes files from the `updates/` directory, sends content to Telegram, and archives processed files in the `posted/` directory. It also logs all actions for debugging and uploads logs as GitHub Actions artifacts.

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
- **Modular Design**:
  - Delegates tasks like secret validation and Markdown processing to external scripts for maintainability.
- **Self-Test Workflow**:
  - Includes a comprehensive self-test workflow to validate the functionality of the Markdown processing script.

---

## Workflows

### **Main Workflow**
The workflow is defined in `.github/workflows/post_to_tg_channel.yml` and includes the following steps:
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
5. **Commit Changes**:
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
5. **Run Markdown Processing Script**:
   - Executes `scripts/process_markdown_files.sh` to process the test files.
6. **Verify Output**:
   - Ensures processed files are archived and logs are generated.
7. **Upload Logs**:
   - Uploads logs as GitHub Actions artifacts for debugging.
8. **Cleanup**:
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

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/troshenkov/WorldTech.git
   cd WorldTech
   ```

2. Add new updates:
   ```bash
   git add updates/
   git commit -m "Add new updates"
   git push origin main
   ```
