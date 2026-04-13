#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# Linux Mint Debloat Script
# Author: You
# =========================================================

LOG_FILE="$HOME/mint-debloat.log"

echo "==== Linux Mint Debloat Script ===="
echo "Log file: $LOG_FILE"
echo

# =========================================================
# Package Groups
# =========================================================

PKGS=(
  # Office / Communication
  libreoffice*
  thunderbird*

  # Media
  rhythmbox*
  hypnotix
  celluloid
  drawing
  pix
  simple-scan

  # Mint Extras (safe subset)
  webapp-manager
  warpinator
  thingy

  # Accessibility
  onboard
  orca
  speech-dispatcher*

  # Network Sharing
  samba*
  avahi*

  # Misc
  transmission-gtk
  yt-dlp
  gucharmap
  baobab

  # Flatpak
  flatpak
  libflatpak0
  gir1.2-flatpak-1.0

  # Snap remnants
  libsnapd-glib-2-1
)

# =========================================================
# Show Planned Removal
# =========================================================

echo "The following packages will be REMOVED:"
printf '%s\n' "${PKGS[@]}"
echo

read -rp "Continue? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Aborted."
  exit 0
fi

# =========================================================
# Simulation
# =========================================================

echo
echo "==== Simulation (no changes made) ===="
sudo apt remove --simulate "${PKGS[@]}" | tee -a "$LOG_FILE"

echo
read -rp "Simulation OK? Proceed with removal? (y/N): " CONFIRM2
if [[ "$CONFIRM2" != "y" ]]; then
  echo "Aborted after simulation."
  exit 0
fi

# =========================================================
# Protect Cinnamon Core
# =========================================================

echo "Protecting Cinnamon core packages..."
sudo apt-mark manual cinnamon cinnamon-session nemo || true

# =========================================================
# Removal
# =========================================================

echo
echo "==== Removing packages ===="
sudo apt remove "${PKGS[@]}" -y | tee -a "$LOG_FILE"

# =========================================================
# Cleanup
# =========================================================

echo
echo "==== Cleaning dependencies ===="
sudo apt autoremove --purge -y | tee -a "$LOG_FILE"
sudo apt clean

# =========================================================
# Snap Block
# =========================================================

echo
echo "==== Blocking Snap ===="
echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref

# =========================================================
# Validation
# =========================================================

echo
echo "==== System Check ===="
sudo apt check | tee -a "$LOG_FILE"
systemctl --failed | tee -a "$LOG_FILE"

echo
echo "==== Done ===="
echo "Log saved to $LOG_FILE"
