# 🖥️ Status Bar Setup for Ubuntu

Automated setup for [indicator-sysmonitor](https://github.com/fossfreedom/indicator-sysmonitor) on Ubuntu — installs everything and configures your status bar with **zero manual steps**.

## What You Get

```
🚀 Net | 💻 CPU 🌡️ Temp | 🎮 GPU VRAM 🌡️ Temp | 🧠 Mem 🔁 Swap | 💾 Disk
```

## Quick Start

```bash
git clone <your-repo-url>
cd Status-Bar
bash install.sh
```

That's it. No GUI clicks, no manual config.

## What It Installs

- **indicator-sysmonitor** (via `ppa:fossfreedom/indicator-sysmonitor`)
- **lm-sensors** (for CPU/GPU temperature readings)
- Custom sensor scripts for NVIDIA GPU VRAM monitoring
- Autostart entry so the indicator launches on login

## Custom Sensors

| Sensor | Description | Script |
|--------|-------------|--------|
| `{nvlogo}` | GPU section marker (🎮) | `~/.indicator-sysmonitor/nv_logo.sh` |
| `{vram}` | NVIDIA VRAM usage (MB) | `~/.indicator-sysmonitor/get_vram.sh` |

## Requirements

- Ubuntu (tested on 24.04)
- NVIDIA GPU with `nvidia-smi` available

## File Structure

```
Status-Bar/
├── install.sh                  # One-liner entry point
├── setup_stats_monitor.sh      # Main setup script
├── config/
│   └── indicator-sysmonitor.desktop  # Autostart entry
├── .gitignore
└── README.md
```
