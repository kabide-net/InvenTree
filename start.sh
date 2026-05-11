#!/bin/bash
# start.sh

set -euo pipefail

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Ensure variables are present
export INVENTREE_DB_ENGINE=sqlite3
export INVENTREE_DB_NAME="$BASE_DIR/dev/db.sqlite3"
export INVENTREE_CONFIG_FILE="$BASE_DIR/dev/config.yaml"

cd "$BASE_DIR"

# Activate the virtual environment!
source dev/venv/bin/activate

echo "Starting Background Worker..."
# Discarding worker logs to avoid file bloat
python3 src/backend/InvenTree/manage.py qcluster > /dev/null 2>&1 &
WORKER_PID=$!

# Ensure the worker is killed when you stop the web server (Ctrl+C)
trap 'echo -e "\nStopping Background Worker..."; kill ${WORKER_PID:-0} 2>/dev/null || true' EXIT

echo "Starting InvenTree Server..."
# Run the server directly in the terminal so you see logs live (not saved to disk)
python3 src/backend/InvenTree/manage.py runserver 0.0.0.0:8000
