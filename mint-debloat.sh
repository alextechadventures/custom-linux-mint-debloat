#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# Linux Mint Debloat Script
# Author: Alex
# =========================================================

LOG_FILE="$HOME/mint-debloat.log"

echo "==== Linux Mint Debloat Script ===="
echo "Log file: $LOG_FILE"
echo

# =========================================================
# Load Package List
# =========================================================

PKG_FILE="$(dirname "$0")/packages.conf"

if [[ ! -f "$PKG_FILE" ]]; then
  echo "ERROR: packages.conf not found!"
  exit 1
fi

echo "Loading package list from: $PKG_FILE"

mapfile -t PKGS < <(grep -Ev '^\s*#|^\s*$' "$PKG_FILE")



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

echo
echo "Packages loaded:"
printf '%s\n' "${PKGS[@]}"
echo

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
