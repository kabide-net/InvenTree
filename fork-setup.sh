#!/bin/bash
# fork-setup.sh
set -euo pipefail

echo "Starting custom fork setup..."

# Data & log directories
mkdir -p ./dev/static
mkdir -p ./dev/media
mkdir -p ./dev/plugins
mkdir -p ./dev/logs

# Persistent SQL configuration
cat << EOF > ./dev/config.yaml
# Custom Codespace Configuration

# Database Configuration
database:
  engine: sqlite3
  name: $(pwd)/dev/db.sqlite3

# Ensure debug is on for dev environment
debug: true
EOF

echo "Fork setup complete. config.yaml generated for SQLite."
