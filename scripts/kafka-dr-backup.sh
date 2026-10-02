#!/bin/bash
set -euo pipefail

BACKUP_DIR="/var/backups/kafka"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/kafka-backup-${TIMESTAMP}.tar.gz"

sudo mkdir -p "$BACKUP_DIR"

echo "===== KAFKA DR BACKUP ====="
echo "Backup: $BACKUP_FILE"

echo "Stopping Kafka for consistent backup..."
sudo systemctl stop kafka

restart_kafka() {
    echo "Starting Kafka..."
    sudo systemctl start kafka
}

trap restart_kafka EXIT

sudo tar -czf "$BACKUP_FILE" \
    /etc/kafka \
    /var/lib/kafka/data

sudo test -s "$BACKUP_FILE"

echo
echo "===== BACKUP CREATED ====="
sudo ls -lh "$BACKUP_FILE"

# Start Kafka BEFORE health verification
sudo systemctl start kafka

# Kafka is running, so no EXIT trap is needed anymore
trap - EXIT

echo
echo "===== KAFKA SERVICE VERIFICATION ====="
sudo systemctl is-active kafka

sudo find "$BACKUP_DIR" \
    -type f \
    -name "kafka-backup-*.tar.gz" \
    -mtime +7 \
    -delete

echo
echo "===== KAFKA DR BACKUP SUCCESSFUL ====="
