#!/bin/bash
set -euo pipefail

BACKUP_DIR="/var/backups/kafka"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/kafka-backup-${TIMESTAMP}.tar.gz"

sudo mkdir -p "$BACKUP_DIR"

echo "===== KAFKA DR BACKUP ====="
echo "Backup: $BACKUP_FILE"

# Create a consistent filesystem backup by briefly stopping Kafka.
sudo systemctl stop kafka

cleanup() {
    sudo systemctl start kafka
}
trap cleanup EXIT

sudo tar -czf "$BACKUP_FILE" \
    /etc/kafka \
    /var/lib/kafka/data

sudo test -s "$BACKUP_FILE"

sudo find "$BACKUP_DIR" \
    -type f \
    -name "kafka-backup-*.tar.gz" \
    -mtime +7 \
    -delete

echo
echo "===== BACKUP CREATED ====="
sudo ls -lh "$BACKUP_FILE"

echo
echo "===== KAFKA SERVICE RESTORE ====="
sudo systemctl is-active kafka
