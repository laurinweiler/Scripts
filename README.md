# Scripts

A collection of maintenance and utility scripts. Each script has a short entry below with a description, usage notes and safety considerations. Add new scripts as separate files and update this README with a brief entry for each.

> [!IMPORTANT]
> These scripts are provided without any warranty. No liability is assumed for any damages or misconfigurations.

## Available scripts

### simple-update

Path: Linux/SimpleUpdateScript.sh

`simple-update` is a maintenance script for Ubuntu systems that updates system packages, performs cleanup, and updates Docker Compose projects. It is intended for a test environment or small home server running a Docker instance that can be easily updated.

Key features:
- Runs `apt-get update` and `apt-get upgrade` in non-interactive mode with safe Dpkg options.
- Cleans unused packages (`apt-get autoremove`, `apt-get autoclean`).
- Updates Docker Compose projects (`docker compose pull` + `docker compose up -d`) with fallback to `docker-compose` if needed.
- Safe execution: `set -euo pipefail`, file-based locking to avoid concurrent runs, logging to `/var/log/simple-update-script.log`, and trap-based cleanup.

🚀 Usage

Make the script executable and run it as root:

```bash
chmod +x Linux/SimpleUpdateScript.sh
sudo ./Linux/SimpleUpdateScript.sh
```

✨ Notes & safety

- Logs: `/var/log/simple-update-script.log`.
- Lock: `/var/lock/simple-update-script.lock` prevents concurrent runs.
- `docker image prune -af` removes unused images; do not add `--volumes` unless you understand the consequences.
- Test manually before scheduling via cron or a systemd timer.


