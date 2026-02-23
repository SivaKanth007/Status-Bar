# 🖥️ Status Bar Setup for Ubuntu

Automated setup for [indicator-sysmonitor](https://github.com/fossfreedom/indicator-sysmonitor) on Ubuntu — one command, zero manual steps.

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

## What It Installs

- **indicator-sysmonitor** (via PPA)
- **lm-sensors** for temperature readings
- Config with NVIDIA VRAM monitoring (inline `nvidia-smi` — no wrapper scripts)
- Autostart entry for login

## Requirements

- Ubuntu (tested on 24.04)
- NVIDIA GPU with `nvidia-smi`

## Files

```
Status-Bar/
├── install.sh              # Entry point
├── setup_stats_monitor.sh  # Main setup
├── config/
│   └── indicator-sysmonitor.desktop
└── README.md
```
