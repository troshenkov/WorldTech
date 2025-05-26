# WorldTech Telegram Automation

![Build Status](https://github.com/troshenkov/WorldTech/actions/workflows/post_news_to_tg.yml/badge.svg)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

## Overview
WorldTech Telegram Automation streamlines the process of posting Markdown news files (with optional images) to a Telegram channel using GitHub Actions.  
It validates input, processes Markdown, posts both text and images, and logs all actions for traceability and debugging.

---

## Features
- **Automated Posting**:  
  Posts Markdown files from the `topics/` directory to a Telegram channel, including images as real Telegram photos.
- **Validation**:  
  Lints Markdown files and checks for common Telegram Markdown issues (like unbalanced brackets).
- **Logging**:  
  Logs all actions for debugging and auditing, with logs uploaded as workflow artifacts.
- **Duplicate Prevention**:  
  Tracks posted files to avoid reposting the same news.
- **Customizable**:  
  Uses environment variables for dynamic configuration.
- **Supports Releases**:  
  Can be configured to post only on GitHub Releases.

---

## Workflows

### Main Workflow
Defined in `.github/workflows/post_news_to_tg.yml`:
1. **Checkout Repository**  
   Clones the repository to the GitHub Actions runner.
2. **Show Environment**  
   Prints environment and workflow context for debugging.
3. **Lint Markdown Files**  
   Uses `markdownlint` to check Markdown formatting.
4. **Validate Telegram Markdown**  
   Checks for unbalanced brackets/parentheses to avoid Telegram formatting errors.
5. **Post Markdown News**  
   Runs `scripts/post_news_to_tg.sh` to send news and images to Telegram.
6. **Upload Logs**  
   Saves logs as GitHub Actions artifacts for debugging and traceability.

---

## Directory Structure
```text
WorldTech/
├── topics/                  # Input directory for Markdown news files
├── scripts/
│   └── post_news_to_tg.sh   # Main posting script
├── .github/
│   └── workflows/
│       └── post_news_to_tg.yml  # Main workflow
├── README.md                # Project documentation
├── LICENSE                  # License information
```

---

## Getting Started

### Prerequisites
- A Telegram bot token (`TELEGRAM_BOT_TOKEN`)
- The chat ID of the target Telegram channel (`TELEGRAM_CHAT_ID`)

### Usage

1. **Add your Markdown news file** to the `topics/` directory.  
   To include an image as a real Telegram photo, use:
   ```markdown
   ![Description](https://example.com/image.jpg)
   ```
2. **Commit and push** your changes to GitHub.
3. The workflow will:
   - Lint and validate your Markdown.
   - Post the news and any images to your Telegram channel.
   - Log all actions for review.

---

## License

This project is licensed under the [MIT License](./LICENSE).

---

## Roadmap

- [ ] **Multi-language Support**: Allow posting news in multiple languages.
- [ ] **Scheduled Posting**: Add support for scheduled (cron-based) news posting.
- [ ] **Release Announcements**: Automatically post GitHub release notes to Telegram.
- [ ] **Advanced Markdown/HTML Support**: Improve formatting and support for more Telegram features.
- [ ] **Admin Notifications**: Notify admins on post failures or important events.
- [ ] **Web Interface**: Optional web dashboard for managing news and monitoring posts.
- [ ] **Unit & Integration Tests**: Expand test coverage for scripts and workflows.
- [ ] **Archive/History**: Move posted news to an archive directory for long-term storage.
- [ ] **Custom Channel Selection**: Allow per-file or per-post channel selection via frontmatter or config.
- [ ] **Enhanced Logging**: Add more detailed logs and error reporting.

---

## Future Features

- **YAML Frontmatter Parsing**: Support for metadata (title, tags, author, etc.) in Markdown files.
- **Batch Posting**: Combine multiple news items into a single Telegram message if needed.
- **Image Uploads**: Support for uploading local images (not just URLs) to Telegram.
- **Preview Mode**: Allow dry-run previews of posts before sending to Telegram.
- **User Feedback**: Collect feedback or reactions from Telegram users.
- **Analytics**: Track post reach and engagement statistics.
