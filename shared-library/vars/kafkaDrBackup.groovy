def call(List hosts = []) {

    echo "======================================"
    echo "   SHARED LIBRARY: KAFKA DR BACKUP"
    echo "======================================"

    hosts.each { host ->

        sh """
            echo "Creating DR backup on ${host}"

            ssh -i /var/lib/jenkins/.ssh/one-click-kafka-key \
              -o BatchMode=yes \
              -o StrictHostKeyChecking=no \
              ubuntu@${host} \
              "sudo /usr/local/bin/kafka-dr-backup.sh"

            echo "DR backup completed on ${host}"
        """
    }

    echo "===== KAFKA DR BACKUP SUCCESSFUL ====="
}
