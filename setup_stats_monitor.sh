#!/bin/bash
set -e

# =============================================================================
#  Status Bar Setup — Fully Automated
#  Installs indicator-sysmonitor, writes config, sets up autostart.
# =============================================================================

CONFIG_FILE="$HOME/.indicator-sysmonitor.json"
AUTOSTART_DIR="$HOME/.config/autostart"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Kill running instance and purge old config
echo "🧹 Cleaning up..."
killall indicator-sysmonitor 2>/dev/null || true
rm -f "$CONFIG_FILE"
rm -rf "$HOME/.indicator-sysmonitor"

# 2. Install packages
echo "📦 Installing indicator-sysmonitor and lm-sensors..."
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y
sudo apt update
sudo apt install indicator-sysmonitor lm-sensors -y
sudo sensors-detect --auto

# 3. Write config (custom sensors + display format — no external scripts needed)
echo "📝 Writing config..."
python3 -c "
import json
cfg = {
    'custom_text': '🚀 {simpleNet} | 💻 {cpu} 🌡️ {cputemp} | 🎮 {nvgpu} {vram} 🌡️ {nvgputemp} | 🧠 {mem} 🔁 {swap} | 💾 {fs///}',
    'interval': 2,
    'on_startup': True,
    'sensors': {
        'vram': ['NVIDIA VRAM', 'nvidia-smi --query-gpu=memory.used --format=csv,noheader']
    }
}
with open('$CONFIG_FILE', 'w') as f:
    json.dump(cfg, f, indent=4, ensure_ascii=False)
print('Config written to $CONFIG_FILE')
"

# 4. Set up autostart
echo "🚀 Setting up autostart..."
mkdir -p "$AUTOSTART_DIR"
cp "$SCRIPT_DIR/config/indicator-sysmonitor.desktop" "$AUTOSTART_DIR/"

# 5. Launch
nohup indicator-sysmonitor &>/dev/null &

echo ""
echo "✅ Done! Status bar is running:"
echo "   🚀 Net | 💻 CPU 🌡️ Temp | 🎮 GPU VRAM 🌡️ Temp | 🧠 Mem 🔁 Swap | 💾 Disk"
