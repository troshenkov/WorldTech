# ROADMAP for `post_to_tg_channel.yml`

## Overview
This roadmap outlines planned improvements and features for the `post_to_tg_channel.yml` workflow. The goal is to enhance reliability, performance, and maintainability.

---

## Milestones

### **1. Short-Term Goals (Q2 2025)**
- [ ] Add retries for Telegram API calls to handle transient errors.
- [ ] Improve error handling with detailed logs and timestamps.
- [ ] Validate Markdown files before processing.
- [ ] Add support for dynamic inline buttons via environment variables.

---

### **2. Medium-Term Goals (Q3 2025)**
- [ ] Process multiple Markdown files in parallel to improve performance.
- [ ] Add support for additional file types (e.g., videos, audio).
- [ ] Implement log verbosity levels (e.g., `INFO`, `DEBUG`, `ERROR`).
- [ ] Notify maintainers on workflow failure via email or Telegram.

---

### **3. Long-Term Goals (Q4 2025)**
- [ ] Use a matrix strategy to test the workflow on multiple environments (e.g., Ubuntu, macOS, Windows).
- [ ] Add automated tests for the workflow logic.
- [ ] Modularize the workflow for reusability across multiple repositories.
- [ ] Add localization support for non-English Telegram channels.

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