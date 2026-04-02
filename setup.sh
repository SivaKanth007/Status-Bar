#!/bin/bash
set -e

# Status Bar Setup — git clone https://github.com/SivaKanth007/Status-Bar.git && cd Status-Bar && bash setup.sh

echo "🧹 Cleaning up old config..."
killall indicator-sysmonitor 2>/dev/null || true
rm -f "$HOME/.indicator-sysmonitor.json"

echo "📦 Installing indicator-sysmonitor..."
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y
sudo apt update && sudo apt install indicator-sysmonitor lm-sensors -y

echo "📝 Writing config..."
cat > "$HOME/.indicator-sysmonitor.json" << 'EOF'
{
    "custom_text": "🚀 {simpleNet} | 💻 {cpu} 🌡️ {cputemp} ❄️{cpu_fan} | 🎮 {nvgpu} {vram} 🌡️ {nvgputemp} ❄️{gpu_fan} | 🧠 {mem} 🔁 {swap} | 💾 {fs///}",
    "interval": 2,
    "on_startup": true,
    "sensors": {
        "vram": ["NVIDIA VRAM", "nvidia-smi --query-gpu=memory.used --format=csv,noheader"],
        "gpu_fan": ["GPU Fan Speed", "sensors | grep -i gpu_fan | awk '{print $2}'"],
        "cpu_fan": ["CPU Fan Speed", "sensors | grep -i cpu_fan | awk '{print $2}'"]
    }
}
EOF

echo "🚀 Setting up autostart..."
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/indicator-sysmonitor.desktop" << 'EOF'
[Desktop Entry]
Name=System Monitor Indicator
Exec=indicator-sysmonitor
Type=Application
Terminal=false
EOF

echo "🎯 Launching indicator..."
nohup indicator-sysmonitor &>/dev/null &

echo ""
echo "✅ Status bar running: 🚀 Net | 💻 CPU | 🎮 GPU | 🧠 Mem | 💾 Disk"
