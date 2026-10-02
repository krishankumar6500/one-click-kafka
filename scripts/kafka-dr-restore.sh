#!/bin/bash
set -euo pipefail

BACKUP_FILE="${1:-}"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 /var/backups/kafka/kafka-backup-YYYYMMDD_HHMMSS.tar.gz"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "===== KAFKA DR RESTORE ====="
echo "Backup: $BACKUP_FILE"

sudo systemctl stop kafka

sudo tar -xzf "$BACKUP_FILE" -C /

sudo chown -R kafka:kafka /var/lib/kafka/data /etc/kafka

sudo systemctl daemon-reload
sudo systemctl start kafka

echo
echo "===== RESTORE VERIFICATION ====="
sudo systemctl is-active kafka

echo
echo "===== DR RESTORE SUCCESSFUL ====="
