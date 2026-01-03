#!/bin/bash
set -euo pipefail

LOG="/var/log/simple-update-script.log"
LOCK="/var/lock/simple-update-script.lock"

# ensure log exists
mkdir -p "$(dirname "$LOG")"
touch "$LOG"
exec >>"$LOG" 2>&1

echo "=== $(date -Iseconds) Starting update ==="

# acquire lock (fd 200)
exec 200>"$LOCK"
flock -n 200 || { echo "Another instance is running"; exit 1; }

cleanup(){
	rc=$?
	echo "=== $(date -Iseconds) Finished with status $rc ==="
	flock -u 200
	exec 200>&-
	exit $rc
}
trap cleanup EXIT

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -o Dpkg::Options::="--force-confdef" \
				-o Dpkg::Options::="--force-confold" \
				upgrade -y
apt-get autoremove -y
apt-get autoclean -y

if command -v docker >/dev/null 2>&1; then
	if docker compose version >/dev/null 2>&1; then
		docker compose pull || true
		docker compose up -d --remove-orphans
	else
		docker-compose pull || true
		docker-compose up -d --remove-orphans
	fi
	docker image prune -af || true
else
	echo "docker not found, skipping docker steps"
fi

exit 0
