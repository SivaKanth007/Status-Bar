#!/bin/bash
set -e

# Status Bar Setup — git clone <repo> && cd Status-Bar && bash setup.sh

killall indicator-sysmonitor 2>/dev/null || true
rm -f "$HOME/.indicator-sysmonitor.json"

sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y
sudo apt update && sudo apt install indicator-sysmonitor -y

cat > "$HOME/.indicator-sysmonitor.json" << 'EOF'
{
    "custom_text": "🚀 {simpleNet} | 💻 {cpu} 🌡️ {cputemp} | 🎮 {nvgpu} {vram} 🌡️ {nvgputemp} | 🧠 {mem} 🔁 {swap} | 💾 {fs///}",
    "interval": 2,
    "on_startup": true,
    "sensors": {
        "vram": ["NVIDIA VRAM", "nvidia-smi --query-gpu=memory.used --format=csv,noheader"]
    }
}
EOF

mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/indicator-sysmonitor.desktop" << 'EOF'
[Desktop Entry]
Name=System Monitor Indicator
Exec=indicator-sysmonitor
Type=Application
Terminal=false
EOF

nohup indicator-sysmonitor &>/dev/null &
echo "✅ Done"
