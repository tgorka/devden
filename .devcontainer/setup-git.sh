#!/bin/bash
set -e

echo "Setting up Git configuration..."

# Get the workspace folder path - fallback to container workspace folder if not set
WORKSPACE_PATH=${containerWorkspaceFolder:-"/workspace/devden"}
echo "Using workspace path: $WORKSPACE_PATH"

# Configure Git safe directory
git config --global --add safe.directory "$WORKSPACE_PATH" || true

# Set Git user information
git config --global user.name "tgorka" || true
git config --global user.email "tomasz@gorka.org.pl" || true

echo "Git configuration complete."
