# Linux Disk Space Full — Find What Is Using Space, Fix the Cause & Verify

A practical Linux troubleshooting project for investigating a filesystem that is running out of disk space.

The workflow is:

CHECK → FIND → UNDERSTAND → FIX → VERIFY

## Problem

A Linux filesystem is nearly full or reaches 100% usage.

Typical symptoms include:

- `No space left on device`
- Applications failing to write files
- Services behaving incorrectly
- Logs failing to write
- Temporary files or application data consuming unexpected space

## Investigation

Start with filesystem usage:

```bash
df -hT
```

Find which top-level directories are consuming space:

```bash
sudo du -xhd1 / | sort -h
```

Investigate `/var`:

```bash
sudo du -xhd1 /var | sort -h
```

Investigate `/var/log`:

```bash
sudo du -xhd1 /var/log | sort -h
```

Find the largest files under `/var/log`:

```bash
sudo du -ah /var/log | sort -h | tail -20
```

Check log files:

```bash
sudo ls -lh /var/log/
```

Check systemd journal usage:

```bash
sudo journalctl --disk-usage
```

Check running services:

```bash
sudo systemctl --type=service --state=running
```

Check warning messages from the current boot:

```bash
sudo journalctl -p warning -b
```

## Targeted Fix

If systemd journal data is identified as the space consumer, remove journal entries older than 7 days:

```bash
sudo journalctl --vacuum-time=7d
```

Do not randomly delete files. Identify the cause first and apply a targeted fix.

## Verify

Check the filesystem again:

```bash
df -hT
```

Check journal usage again if it was the cause:

```bash
sudo journalctl --disk-usage
```

## Script

The included script performs the investigation steps without deleting anything:

```bash
chmod +x disk_space_troubleshooting.sh
sudo ./disk_space_troubleshooting.sh
```

The script checks:

- Filesystem usage
- Top-level directory usage
- `/var` usage
- `/var/log` usage
- Largest files in `/var/log`
- Systemd journal usage
- Running services
- Current-boot warnings

Journal cleanup is intentionally not automatic. If the investigation shows that old journal data is the cause, run:

```bash
sudo journalctl --vacuum-time=7d
```

Then verify:

```bash
df -hT
```

## Commands Used

```text
df -hT
du
sort
tail
ls
journalctl
systemctl
```

## Troubleshooting Method

```text
PROBLEM
   ↓
CHECK FILESYSTEM
   ↓
FIND WHERE SPACE IS USED
   ↓
INVESTIGATE THE CAUSE
   ↓
APPLY TARGETED FIX
   ↓
VERIFY
```
