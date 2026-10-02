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

echo
echo "===== STARTING KAFKA ====="
sudo systemctl start kafka

trap - EXIT

echo "Waiting for Kafka service to become active..."

for i in {1..30}; do
    if sudo systemctl is-active --quiet kafka; then
        echo
        echo "===== KAFKA SERVICE ACTIVE ====="
        sudo systemctl is-active kafka

        sudo find "$BACKUP_DIR" \
            -type f \
            -name "kafka-backup-*.tar.gz" \
            -mtime +7 \
            -delete

        echo
        echo "===== KAFKA DR BACKUP SUCCESSFUL ====="
        exit 0
    fi

    echo "Kafka is starting... attempt $i/30"
    sleep 2
done

echo
echo "===== KAFKA FAILED TO BECOME ACTIVE ====="
sudo systemctl status kafka --no-pager -l || true
sudo journalctl -u kafka -n 30 --no-pager || true
exit 1
