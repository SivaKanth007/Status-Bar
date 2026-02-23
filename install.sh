#!/bin/bash
# Quick installer — run this after cloning the repo
# Usage: git clone <repo-url> && cd Status-Bar && bash install.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SCRIPT_DIR/setup_stats_monitor.sh"
echo "🚀 Running setup..."
bash "$SCRIPT_DIR/setup_stats_monitor.sh"
