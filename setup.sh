#!/bin/bash
set -e

# Status Bar Setup — One script, zero manual steps.
# Usage: git clone <repo> && cd Status-Bar && bash setup.sh

CONFIG="$HOME/.indicator-sysmonitor.json"

# Cleanup
killall indicator-sysmonitor 2>/dev/null || true
rm -f "$CONFIG"
rm -rf "$HOME/.indicator-sysmonitor"

# Install
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y
sudo apt update
sudo apt install indicator-sysmonitor lm-sensors -y
sudo sensors-detect --auto

# Config
cat > "$CONFIG" << 'EOF'
{
    "custom_text": "🚀 {simpleNet} | 💻 {cpu} 🌡️ {cputemp} | 🎮 {nvgpu} {vram} 🌡️ {nvgputemp} | 🧠 {mem} 🔁 {swap} | 💾 {fs///}",
    "interval": 2,
    "on_startup": true,
    "sensors": {
        "vram": ["NVIDIA VRAM", "nvidia-smi --query-gpu=memory.used --format=csv,noheader"]
    }
}
EOF

# Autostart
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/indicator-sysmonitor.desktop" << 'EOF'
[Desktop Entry]
Name=System Monitor Indicator
Exec=indicator-sysmonitor
Type=Application
Terminal=false
EOF

# Launch
nohup indicator-sysmonitor &>/dev/null &
echo "✅ Status bar running: 🚀 Net | 💻 CPU | 🎮 GPU | 🧠 Mem | 💾 Disk"
