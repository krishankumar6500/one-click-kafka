def call(List hosts = []) {

    echo "======================================"
    echo "   SHARED LIBRARY: KAFKA HEALTH CHECK"
    echo "======================================"

    hosts.each { host ->

        sh """
            echo "Checking Kafka node: ${host}"

            ssh -i /var/lib/jenkins/.ssh/one-click-kafka-key \
              -o BatchMode=yes \
              -o StrictHostKeyChecking=no \
              ubuntu@${host} \
              "sudo systemctl is-active kafka"
        """
    }

    echo "===== KAFKA HEALTH CHECK PASSED ====="
}
