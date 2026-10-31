## 1.4.0 - Full Telegram Parity: Pinned Messages & Chats, Location Sharing, Sticker Picker & Chat Folders

### 📌 Pinned Messages & Pinned Chats
- 📍 Added persistent Telegram-style **Pinned Message Banner** to chat header with smooth scroll-to-message jump and unpin control
- 🔝 Added **Pin to Top** in chat context menus with persistent sorting at the top of the chat list and pin indicator badges

### 🗺️ Live Location Sharing
- 📍 Added **Location Sharing** option to attachment menu using `navigator.geolocation`
- 🗺️ Generates interactive OpenStreetMap coordinate markers directly inside messages

### 😊 Telegram Emoji & Sticker Picker
- 🎭 Added dedicated popup panel with categorized emojis (Smileys, Gestures, Hearts, Ocean)
- 🚀 Includes Telegram-style graphic stickers (`🌊`, `🐳`, `❤️‍🔥`, `🎉`, `🚀`, `😎`, `🤯`, `💎`, `👑`) with single-tap instant sending

### 📁 Telegram-Style Chat Folders
- 📂 Added responsive folder tabs across the top of the chat list: **All**, **Personal**, **Groups**, and **Channels**
- ⚡ Real-time filtering with badge counters and animated tab switching

## 1.3.0 - Telegram-Grade Sound & Vibration Alerts, Full Multi-Language System & 3D Logo Overhaul

### 🔔 SMS & Telegram-Style Notification Alerts
- 🎵 Dual-tone synthesised Telegram/SMS message incoming chime (`659.25Hz -> 880Hz / 1318Hz`) via Web Audio API
- 📳 Mobile haptic vibration patterns: `[200, 100, 200, 100, 250]` on incoming messages, continuous `[500, 250, 500]` on incoming calls
- 📲 Background & lockscreen notification dispatcher when app/tab is hidden or minimized
- 📞 Full ringing loop and device vibration in call screens

### 🌐 Global Multi-Language System (Telegram-Style i18n)
- 🌍 Complete internationalization engine supporting 9 global languages:
  - 🇺🇸 English (`en`)
  - 🇮🇷 فارسی / Persian (`fa`)
  - 🇸🇦 العربية / Arabic (`ar`)
  - 🇷🇺 Русский / Russian (`ru`)
  - 🇪🇸 Español / Spanish (`es`)
  - 🇩🇪 Deutsch / German (`de`)
  - 🇫🇷 Français / French (`fr`)
  - 🇹🇷 Türkçe / Turkish (`tr`)
  - 🇨🇳 简体中文 / Chinese (`zh`)
- ⚙️ Interactive Language settings panel with instant switching and automatic RTL/LTR document layout adaptation
- 💾 Persistent language preferences saved across reloads

### 🌊 3D Emblem & OpenGraph Overhaul
- 🖼️ Prominently integrated official transparent 3D ocean bubble wave emblem across desktop empty states, auth screens, splash loader, and About modal
- 🌐 Added OpenGraph (`og:image`, `og:title`, `og:description`) and Twitter cards for instant social preview card rendering

## 1.2.0 - Official 3D Transparent Logo & Full Branding Clean

### 🌊 Official 3D Transparent Ocean Logo
- 🎨 Added custom 3D glass bubble wave emblem with pure transparent alpha background
- 📱 Generated high-resolution PWA & web icons (16px, 32px, 180px, 192px, 512px, maskable) and embedded transparent vector SVG
- ⚡ Removed all flat placeholders and unbranded watermarks

### ☀️ Light Mode Bug Fix & High-Contrast Polish
- 🛠️ Fixed corrupted Tailwind color tokens where light surfaces were overridden by dark hexes
- 🌈 Crisp, readable message bubbles and reactive emoji badge pills across both light and dark themes
- 🌓 Smooth theme switching and background color persistence

### 🏷️ Global Rebranding & Cleanup
- 🧼 Replaced all remaining legacy labels, placeholders, and notification badges with **OceanGram**
- 🛡️ Preserved backend protocol compatibility while presenting a unified, mature frontend

## 1.1.0 - Telegram-Style Message Reaction Badges & Obsidian Theme

### ✨ Real Telegram-Style Message Reaction Badges
- 💬 Reacting to a message now attaches the interactive emoji reaction pill directly below the message bubble
- ⚡ Multiple reactions with counts, user toggle, bounce animation, and reactive store persistence
- 🎭 Clicking existing reaction badge on message increments/toggles reaction immediately

### 💎 Luxury Obsidian Dark Aesthetic (Anti-Childish Overhaul)
- 🌌 Replaced washed-out light green pastel look with deep oceanic obsidian (`#070a13`, `#090e18`)
- 🎨 Refined typography, crisp glassmorphic borders, and high-contrast readable message cards
- 🖤 Defaulted to luxury dark mode for instant professional feel

## 1.0.1 - Smart CLI Menu & Live Update Checker

### ⚡ CLI & Update Features
- 🔔 Automatic GitHub update detection: typing `oceangram` notifies the administrator in English if a new release/commit is available
- ⌨️ Interactive numbered control menu: press `3` to automatically pull updates, rebuild containers, and restart services
- 📊 Instant status (`1`), live logs (`2`), restart (`4`), stop (`5`), start (`6`), and SSL cert renew (`7`)

## 1.0.0 - OceanGram Official Release

### ✨ Visual Redesign & Telegram-Grade Animations
- 🌊 Complete brand transformation to **OceanGram** with fluid cyan/azure oceanic styling
- 🎭 Telegram-style context menu overlays with frosted glass backdrop blur (`backdrop-blur-2xl`)
- ⚡ Floating emoji reaction row (`👍`, `❤️`, `🔥`, `😂`, `👏`, `⚡`, `🌊`) with spring scale & bounce micro-interactions
- 💬 Springy message entrance physics, pulsing online status rings, and animated oceanic wave shimmer
- 🎨 Redesigned vector branding: high-res SVG logos, web manifest, and custom themes

### 🚀 Production Deployment & Ubuntu Installer
- ⚡ 1-Line automated interactive wizard for Ubuntu / Debian servers
- 🔐 Automatic Let's Encrypt SSL generation & renewal hooks via Certbot (with SAN SSL fallback)
- 🗄️ Multi-database engine architecture: SQLite3 (in-memory + WAL) and PostgreSQL (Docker or external)
- 🛡️ Sanction-safe setup with automatic anti-sanction DNS injection and local package repositories
- 🌐 Smart host port 80/443 conflict resolution and global CLI command (`oceangram`)

## 0.13.2

### New Features

- 🌐 Optional coturn TURN server setup in the deployment script

### Bug Fixes

- 🎬 Preserve chronological ordering for video messages on chat reopen
- 🛠️ Resolve relative paths for database restore command and polished restore database system
- 🖼️ Prevent false avatar deletion from storage buckets
- 🗃️ Enable database health check in SQLite mode
- 🏅 Conditionally render verified badge in desktop user menu
- 🔗 Display channel type in invite modal

## 0.13.1

### Bug Fixes

- 📞 Await async session resolution in call routes for PostgreSQL
- 🛠️ Check and auto-upgrade lego binary when newer release is available
- 📜 Update lego CLI invocation syntax for lego v5 compatibility
- 🪣 Ignore directory marker keys during orphan avatar pruning in object storage

## 0.13.0

### New Features

- 📞 WebRTC voice and video calls with real-time signaling over WebSocket
- 📜 Calls history page with detailed call logs and deletion support
- ➕ New call modal to initiate voice and video calls with direct message contacts
- ⚙️ Call configuration settings in admin panel and environment variables
- 🌐 TURN server health check card in the Services tab

### Improvements

- 🎨 Desktop sidebar redesign with integrated user button and settings view
- 🔔 Clickable permission prompt bars with dismiss icon button

## 0.12.4

### New Features

- 📡 On-demand remote channel polling with tick endpoint for sleep-friendly deployments
- 🔑 Owner-only secrets section in the admin panel settings tab
- 🛠️ Remote channel management directly in the admin panel channel modal
- ⏱️ Remote channel tick mode option in settings

### Improvements

- 🔒 Reworked `REMOTE_CHANNEL_UI` flag to restrict UI and API to admins when disabled
- 🎨 Moved insecure connection warning banner to the chats list
- 🧹 Removed unused dependencies and updated package versions

### Bug Fixes

- 🔴 Forward Redis auth to BullMQ connections

## 0.12.3

### New Features

- 🗃️ Postgres database ping card in the Services tab
- ⚙️ New configuration options in admin settings
- 🗄️ Admin audit logs persisted in the database instead of the log file

### Improvements

- 🔁 Retry mirror dispatch logic for remote workers
- 📋 New log actions for remote channel events and nginx reload
- 🔗 Docker and Railway social links in settings

### Bug Fixes

- 🧹 Delete remote bucket objects and local video thumbnails on message file retention expiry
- 🖼️ Prevent avatar URL clearing when remote storage is configured
- 🔕 Prune stale push subscriptions on 401/403 auth errors without warning logs for expired entries
- 📨 Fix public channel messages endpoint hanging on un-awaited messages promise

## 0.12.2

### New Features

- 🖼️ Object storage avatar uploads
- 🪣 Unified object-storage layout
- 📡 Guided Telegram remote channel setup in the admin panel with Services tab status and remote media mirroring via worker
- 📋 Worker log tab in the admin panel
- 🔗 Object storage proxy support

### Bug Fixes

- 🔒 Presign rate limiting on upload endpoints
- 👤 Postgres banned-user handling on login
- 📅 Postgres timestamp defaults causing Invalid Date on new messages
- 🛡️ Fail fast on secret mismatch instead of overwriting the database

## 0.12.1

### Bug Fixes

- 🧹 Clean up orphaned rows during migration
- ⚙️ Prefer env values over database secrets and avoid unnecessary file writes
- 🛠️ Refactored installer version comparison logic

## 0.12.0

### New Features

- 🐘 PostgreSQL database support
- 🪣 S3-compatible object storage for file uploads
- 🎬 Standalone media worker for video transcoding
- 📴 Offline-first chat with pending message queue, auto-resend on reconnect, and cached history access
- 🔌 Bidirectional WebSocket realtime gateway
- 🛡️ Emergency admin claim endpoint and UI for recovering admin access
- 👥 Auto-add new users to public chats from the admin panel
- 🔎 Unified filter popover for admin users and chats lists
- 🔴 Redis support for background queues, caching, and sessions
- 📦 Installer update menu with downgrade support, secret generation, and worker service logs
- 📥️ One-click Railway and Render deployment blueprints

### Improvements

- 🆔 UUID primary keys for users, chats, and messages
- 🔒 Auto-generated secrets stored in the database instead of secondary env files
- 🎨 Chat list redesign with borderless rows, larger typography, and permission prompts moved to the header
- 📅 Smarter message date labels with dynamic day grouping
- 🐋 Docker images with PostgreSQL client v18, improved health checks, and dedicated worker image
- 💾 More reliable Docker database backups with proper error reporting
- 🔧 Encrypted thumbnails and improved file encryption handling
- 📖 Cloud deployment, PostgreSQL SSL, and media worker documentation

### Bug Fixes

- 🚪 Stay signed in with a clear offline state instead of redirecting to login when the server is unreachable
- 📨 Keep pending messages in sending state on network errors instead of failing them

## 0.11.4

### New Features

- 👥 Add all eligible members to groups directly from the admin panel
- 🛠️ Toggle verified status for users and chats via new database commands

### Improvements

- 💾 Preserve admin data, logs, service availability, and sidebar state when navigating away from the admin panel
- ⚙️ Show environment variable names for settings locked by `.env`
- 🎨 Add quick color refresh controls and randomized default colors for new users and chats
- 🔎 Add clear buttons to admin search inputs
- 💬 Replace browser hover hints with consistent, accessible in-app tooltips
- 🏅 Show verification and owner badges consistently in invite pages and admin chat editing

### Bug Fixes

- 🧮 Allow disabled message/file retention settings to remain disabled when set to `0`
- ✍️ Preserve unsaved admin settings edits during background data refreshes
- ♻️ Disable default settings restore button when there are no non-default settings to restore
- 📱 Preserve mobile pagination scroll clearance in the admin panel

## 0.11.3

### Security
- 🔧 Fixed a message at-rest encryption bypass caused by untrusted ciphertext-marker handling.


## 0.11.2

### New Features

- 🏅 Verified and role badge system for users and chats

### Improvements

- 🐋 Production-ready Docker and cloud platform deployment with container health checks
- 🔌 Configurable server bind address and graceful shutdown handling
- ⚡ Faster admin panel with server-side pagination for users, chats, and logs
- 🔢 Adjustable page-size selector on admin pagination controls
- 📊 Smoother dashboard stats with cached system metrics
- 💨 Snappier chat experience with reduced SSE-driven refetching and debounced chat list reloads
- 🎨 Refreshed upload menu styling to match the new dropdown design

### Bug Fixes

- 💬 Keep the connection alive when navigating in and out of the admin panel
- 🔄 Sidebar now updates instantly when members are added, removed, or have their role changed
- 🎨 Include reply author color in message replies
- 🚪 Sign out all clients correctly after a database reset or restore
- 🛠️ Service control now works on Docker deployments

## 0.11.1

### New Features

- 🧠 Smart caching with proper silent background updates for admin panel

### Improvements

- 📊 Increased admin data limits to 1000 rows per tab
- 🚀 Raised API rate limit to 1000 req/15min and excluded SSE endpoint
- 📜 Auto-scroll system logs to bottom on load for better visibility
- 📱 Responsive log windows on mobile screens (40vh on mobile, 60vh on desktop)
- 🌐 Enhanced bidirectional text handling in log descriptions

### Bug Fixes

- 🔒 Resolved permission issues for logs and service control on dedicated-user deployments
- 👥 Fixed presence status computed server-side on initial load (eliminates ghost green dot)

## 0.11.0

### New Features

- 🛡️ Admin Panel with full user and chat management
- 👑 Owner role with elevated permissions
- ⚙️ Runtime settings configurable from the admin panel (moved from `.env` to database)
- 📋 File-based audit logs with multi-source logs page
- 🔒 `ADMIN_PANEL` env flag to disable the admin panel entirely
- 🧑‍💼 Unified create/edit user modal with avatar and inline password reset
- 💬 Danger zone — clear all messages and reset the database
- 🔁 App version check and service restart/stop from Actions tab
- 🖥️ Admin presence pings with idle auto-exit
- 💡 Prompt to create an owner user after a fresh install
- 📖 Songbird Wiki website at `docs.songbird.website`
- 🎨 Settings page design improvements to be more touch-friendly for mobile screens
- 🕑 Show "last seen" timestamp status for non-invisible users
- 🔧 Bug fixes

## 0.10.3

### New Features

- 📡 Songbird as a second Remote Channel source provider
- 💬 Message preview toggle in notification settings

### Improvements

- 📱 Tap chats button on mobile to scroll back to top
- ⌨️ Deselect chat with Escape key
- 🔢 Compact unread count format (e.g. 1K+)
- 🔕 Skip push notifications for users with an active SSE connection
- 🔒 Centralized and stricter username validation
- 💨 Performance optimizations on hot paths
- 🔧 Bug fixes

## 0.10.2

- 🎨 UI design update for the about page and queue status section
- 🖱️ Infinite scroll on chat members list
- 🦻 Accessibility improvements
- 💨 Performance optimization
- 🔧 Bug fixes

## 0.10.1

### Improvements

- 📄 Remote channel queue status report on channel profile.
- 🎛️ Remote channel queue action buttons to pause, skip or test connection.
- 📡 Force remote channel client reset on connection erros to prevent reconnection deadlock.
- 📨 Parallelize remote channel source polling.
- 🔗 Proxy configuration to reach push notification endpoints.
- 💨 Remote channel optimization and loading speed improvements.
- ⚙️ env vars to disable remote channel option or stream media option in UI.
- ➕ Remote channel configuration support in "Create Chat" and "Edit Chat" database commands.
- 🔧 Bug fixes

## 0.10.0

### New Features

- 📡 Remote Channel

### Improvements

- 🔗 Invite Link System simplification
- 🎨 Create/Edit Chat modal UI overhaul
- 🔧 Bug fixes

## 0.9.2

- ✨ Chat window build animations
- 🔔 Push Notification system improvements
- 🎨 UI/UX improvements
- 📥 Installer script UI improvements
- 🐋 TLS support using self-signed SSL certs in Docker
- 🔧 Bug fixes

## 0.9.1

- 🔧 UI bug fixes
- 💨 Client-side loading optimization

## 0.9.0

### New Features

- 📥 Offline Update via script
- 🔒 Client-Server Encryption
- ↪️ Forward Message
- 🗑️ Delete Message
- ✏️ Edit Message
- 📃 Built-in Context Menu
- ℹ️ About Page
- 💬 Text message auto-deletion option
- 📜 6-Days certificate option for IPs via script
- ♻️ Database backup restoration
- 🚫 "Ban user" database command

### Improvements

- 🔍 Zooming improvements for media
- ⌨️ Typing Indicator
- ✨ UI/UX Improvements
- 📜 Certificate Installation with SSL key files
- ➕ "Create chat" database command
- ✏️ "Edit chat" database command
- 👤 "Edit user" database command
- ⚙️ Custom port setting option for nginx during script installation domain mode.
- 💨 Increased loading speed and server-side resource usage improvements
- 🔧 Along with a lot of bug fixes!