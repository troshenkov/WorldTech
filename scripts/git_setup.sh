#!/bin/bash
# ==================================================================================================
# File: scripts/git_setup.sh
#
# Description:
#   This script configures Git user information for automated commits and pushes performed by
#   GitHub Actions. It sets the Git user name and email to ensure that changes made by the workflow
#   are properly attributed.
#
# Usage:
#   This script is called by GitHub Actions workflows to prepare Git for committing and pushing
#   changes, such as archived files or logs, back to the repository.
# ==================================================================================================

# Configure Git user information
git config user.name "GitHub Actions Bot"
git config user.email "actions@github.com"