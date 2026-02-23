#!/bin/bash
set -e

# =============================================================================
#  Status Bar Setup — Fully Automated
#  Installs indicator-sysmonitor, creates custom sensors, writes config,
#  and sets up autostart. Zero manual steps required.
# =============================================================================

MON_DIR="$HOME/.indicator-sysmonitor"
CONFIG_FILE="$HOME/.indicator-sysmonitor.json"
AUTOSTART_DIR="$HOME/.config/autostart"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Kill running instance and purge old configs
echo "🧹 Cleaning up old configurations..."
killall indicator-sysmonitor 2>/dev/null || true
rm -f "$CONFIG_FILE"
rm -rf "$MON_DIR"

# 2. Create the custom scripts directory
mkdir -p "$MON_DIR"

# 3. Install indicator-sysmonitor and sensors
echo "📦 Installing indicator-sysmonitor and lm-sensors..."
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor -y
sudo apt update
sudo apt install indicator-sysmonitor lm-sensors -y
sudo sensors-detect --auto

# 4. Create custom sensor scripts
echo "⚙️  Writing custom sensor scripts..."

cat > "$MON_DIR/get_vram.sh" << 'EOF'
#!/bin/bash
nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits
EOF

cat > "$MON_DIR/nv_logo.sh" << 'EOF'
#!/bin/bash
echo "🎮"
EOF

chmod +x "$MON_DIR/get_vram.sh" "$MON_DIR/nv_logo.sh"

# 5. Write the indicator-sysmonitor config (replaces all manual GUI steps)
echo "📝 Writing indicator-sysmonitor config..."
cat > "$CONFIG_FILE" << 'EOF'
{
    "custom_text": "🚀 {simpleNet} | 💻 {cpu} 🌡️ {cputemp} | {nvlogo} {nvgpu} {vram} 🌡️ {nvgputemp} | 🧠 {mem} 🔁 {swap} | 💾 {fs///}",
    "interval": 2,
    "on_startup": true,
    "sensors": {
        "nvlogo": ["NVIDIA GPU Logo", "NVLOGO_CMD_PLACEHOLDER"],
        "vram": ["NVIDIA VRAM Usage", "VRAM_CMD_PLACEHOLDER"]
    }
}
EOF

# Replace placeholders with actual paths (handles $HOME correctly in JSON)
sed -i "s|NVLOGO_CMD_PLACEHOLDER|$MON_DIR/nv_logo.sh|g" "$CONFIG_FILE"
sed -i "s|VRAM_CMD_PLACEHOLDER|$MON_DIR/get_vram.sh|g" "$CONFIG_FILE"

# 6. Set up autostart so indicator launches on login
echo "🚀 Setting up autostart..."
mkdir -p "$AUTOSTART_DIR"
cp "$SCRIPT_DIR/config/indicator-sysmonitor.desktop" "$AUTOSTART_DIR/" 2>/dev/null || \
cat > "$AUTOSTART_DIR/indicator-sysmonitor.desktop" << 'EOF'
[Desktop Entry]
Name=System Monitor Indicator
Comment=Basic sysmonitor indicator applet
Exec=indicator-sysmonitor
Terminal=false
StartupNotify=true
Type=Application
Categories=Utility;
Icon=gnome-system-monitor
EOF

# 7. Launch the indicator
echo "🎯 Starting indicator-sysmonitor..."
nohup indicator-sysmonitor &>/dev/null &

echo ""
echo "====================================================================="
echo "  ✅ SETUP COMPLETE — NO MANUAL STEPS REQUIRED!"
echo "====================================================================="
echo "  Your status bar is now showing:"
echo "  🚀 Net | 💻 CPU 🌡️ Temp | 🎮 GPU VRAM 🌡️ Temp | 🧠 Mem 🔁 Swap | 💾 Disk"
echo ""
echo "  Config:    $CONFIG_FILE"
echo "  Scripts:   $MON_DIR/"
echo "  Autostart: $AUTOSTART_DIR/indicator-sysmonitor.desktop"
echo "====================================================================="
