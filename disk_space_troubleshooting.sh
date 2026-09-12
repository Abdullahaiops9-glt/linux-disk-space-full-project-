#!/bin/bash

# Linux Disk Space Troubleshooting
# Investigation only — no files are deleted automatically.

set -u

echo "=========================================="
echo " Linux Disk Space Troubleshooting"
echo "=========================================="
echo

echo "[1] Filesystem usage"
echo "------------------------------------------"
df -hT
echo

echo "[2] Top-level directory usage"
echo "------------------------------------------"
sudo du -xhd1 / 2>/dev/null | sort -h
echo

echo "[3] /var usage"
echo "------------------------------------------"
sudo du -xhd1 /var 2>/dev/null | sort -h
echo

echo "[4] /var/log usage"
echo "------------------------------------------"
sudo du -xhd1 /var/log 2>/dev/null | sort -h
echo

echo "[5] Largest files/directories under /var/log"
echo "------------------------------------------"
sudo du -ah /var/log 2>/dev/null | sort -h | tail -20
echo

echo "[6] Log directory listing"
echo "------------------------------------------"
sudo ls -lh /var/log/
echo

echo "[7] Systemd journal disk usage"
echo "------------------------------------------"
sudo journalctl --disk-usage
echo

echo "[8] Running services"
echo "------------------------------------------"
sudo systemctl --type=service --state=running
echo

echo "[9] Warning messages from current boot"
echo "------------------------------------------"
sudo journalctl -p warning -b
echo

echo "=========================================="
echo " Investigation complete"
echo "=========================================="
echo
echo "No files were deleted by this script."
echo "If old systemd journal data is confirmed as"
echo "the cause, a targeted cleanup can be run with:"
echo
echo "sudo journalctl --vacuum-time=7d"
echo
echo "Then verify again with:"
echo
echo "df -hT"
