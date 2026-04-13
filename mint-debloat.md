# Linux Mint Debloat Log

## System Info
- Kernel: Linux 6.17.0-20-generic
- Desktop: Cinnamon

---

## Removed Packages
libreoffice*
thunderbird*
rhythmbox*
hypnotix
celluloid
drawing
pix
simple-scan

mintbackup
mintchat
mintstick
mintwelcome

webapp-manager
warpinator
thingy

onboard
orca
speech-dispatcher*

samba*
avahi*

transmission-gtk
yt-dlp
gucharmap
baobab

flatpak
libflatpak0
gir1.2-flatpak-1.0

libsnapd-glib-2-1

---

## Notes
Removing:
- LibreOffice suite
- Thunderbird
- Media apps (Rhythmbox, Celluloid)
- Mint extras (Waripnator, Webapp Manager, etc.)
- Accessibility tools
- Network sharing (Samba, Avahi)
- Flatpak stack
- Snap remnants

Reason:
Minimal system, reduce RAM/disk usage, prefer manual tools

---

## Issues Encountered
Removing:
- mintbackup
- mintchat
- mintstick
- mintwelcome

Reason:
Breaks cinnamon-session-connamon which is required for login with cinnamon. If that happens, reinstall it with `sudo apt install --reinstall cinnamon-session cinnamon-desktop-environment cinnamon`.

---

## Critical Findings

Removing some Mint utilities (mintbackup, mintwelcome, etc.)
can trigger removal of cinnamon-session due to meta-package dependencies.

Lesson:
Meta-packages can silently break desktop environments

---
