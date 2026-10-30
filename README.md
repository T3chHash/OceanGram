[English](/README.md) | [فارسی](/README.fa_IR.md)

<div align="center">

# 🌊 OceanGram

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/T3chHash/OceanGram)
[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Ubuntu-20.04%20%7C%2022.04%20%7C%2024.04-orange.svg)](#one-line-installer-ubuntu)

**Modern, Ultra-Fast, Self-Hosted Real-Time Messenger with Oceanic Fluid Animations**

</div>

---

## ⚡ One-Line Installer (Ubuntu / Debian)

Install and launch OceanGram on any Ubuntu or Debian server with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/T3chHash/OceanGram/main/install.sh | sudo bash
```

The automated script configures:
- 🐳 **Docker & Docker Compose** runtime
- 🔐 **SSL / HTTPS** (automated certificates)
- 🌐 **Nginx Reverse Proxy** with WebSocket & SSE optimizations
- ⚙️ **CLI Tool (`oceangram`)** for instant management
- 🛡️ **Zero-leak environment & secure token generation**

### Managing OceanGram
Once installed, manage your instance effortlessly:
```bash
oceangram status    # Check running services
oceangram logs      # Stream live logs
oceangram restart   # Restart services
oceangram update    # Pull latest release and rebuild
```

---

## 💎 Features & Redesign Highlights

- 🌊 **Oceanic Fluid Design**: Complete modern visual overhaul with luminous cyan/azure tones, glowing ripples, glassmorphic surfaces, and responsive micro-interactions.
- ✨ **Buttery Smooth Animations**: Spring message entrance transitions, ambient glowing status halos, and floating accents.
- 💬 **Universal Messaging**: Direct messages, group chats, broadcast channels, and rich media sharing.
- 🎙️ **Voice & Video Calls**: Low-latency peer-to-peer WebRTC calls with real-time waveform visualization.
- 📁 **Media Processing**: Video transcoding, image compression, and voice note transcription.
- 🔔 **Instant Web Push**: PWA notifications via VAPID.
- 🛡️ **Full Admin Suite**: User moderation, retention controls, database backups, and metrics.
- 🌍 **Bilingual & Responsive**: English and Persian (فارسی / Vazirmatn) support with full mobile touch optimization.

---

## 🚀 Manual Docker Run

If you prefer launching with Docker Compose directly:

```bash
git clone https://github.com/T3chHash/OceanGram.git /opt/oceangram
cd /opt/oceangram
docker compose up -d --build
```

Access your instance at `https://localhost` or your server's IP address.

---

## 📜 License

OceanGram is licensed under the [MIT License](LICENSE).
