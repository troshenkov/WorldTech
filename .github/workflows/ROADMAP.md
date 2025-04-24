# ROADMAP for `post_to_tg_channel.yml`

## Overview
This roadmap outlines planned improvements and features for the `post_to_tg_channel.yml` workflow. The goal is to enhance reliability, performance, and maintainability while adding new features to improve user experience.

---

## Milestones

### **1. Short-Term Goals (Q2 2025)**
- [ ] **Retry Logic**: Add retry logic with exponential backoff for failed Telegram API calls.
- [ ] **Enhanced Logging**: Include verbosity levels (`INFO`, `DEBUG`, `ERROR`) for better debugging.
- [ ] **Markdown Validation**: Validate Markdown files before processing to ensure proper formatting.
- [ ] **Custom Inline Buttons**: Allow users to define custom inline buttons via metadata in Markdown files.
- [ ] **Error Notifications**: Notify maintainers via email or Telegram when the workflow fails.

---

### **2. Medium-Term Goals (Q3 2025)**
- [ ] **Support for Additional File Types**: Add support for posting videos and audio files to Telegram.
- [ ] **Localization Support**: Enable multi-language support for posts using a localization file (e.g., JSON or YAML).
- [ ] **Batch Processing**: Process large numbers of Markdown files in batches to avoid hitting Telegram API rate limits.
- [ ] **Parallel Processing**: Process multiple Markdown files in parallel to improve performance.
- [ ] **Custom Scheduling**: Allow users to define custom schedules for posting Markdown files via a configuration file.

---

### **3. Long-Term Goals (Q4 2025)**
- [ ] **Web Interface**: Create a simple web interface for uploading Markdown files and monitoring workflow status.
- [ ] **Distributed Processing**: Use a distributed system (e.g., AWS Lambda, Kubernetes) for processing Markdown files at scale.
- [ ] **Advanced Markdown Support**: Use a Markdown parser library to handle complex Markdown syntax (e.g., tables, code blocks).
- [ ] **Matrix Strategy**: Test the workflow on multiple environments (e.g., Ubuntu, macOS, Windows) using GitHub Actions matrix builds.
- [ ] **Analytics**: Track the number of posts, images, and documents sent using analytics tools.

---

## Contribution Guidelines
- Contributions are welcome! Please open an issue or pull request to discuss proposed changes.
- Follow the repository's coding standards and ensure all changes are tested.

---

## Timeline
| Milestone           | Target Completion |
|---------------------|-------------------|
| Short-Term Goals    | Q2 2025          |
| Medium-Term Goals   | Q3 2025          |
| Long-Term Goals     | Q4 2025          |

---

## Contact
For questions or suggestions, please contact Dmitry Troshenkov at <troshenkov.d@gmail.com>.