@Library('oneClickKafka') _

pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        ANSIBLE_DIR = 'ansible'
        INVENTORY   = 'ansible/inventory.ini'

        KAFKA1 = '172.31.27.172'
        KAFKA2 = '172.31.20.48'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Read Config') {
            steps {
                sh '''
                    echo "======================================"
                    echo " One-Click Apache Kafka Deployment"
                    echo "======================================"
                    echo "Kafka Version : 3.9.2"
                    echo "Cluster       : KRaft"
                    echo "Brokers       : 2"
                    echo "======================================"
                '''
            }
        }

        stage('Terraform Infrastructure Check') {
            steps {
                sh '''
                    echo "======================================"
                    echo "      TERRAFORM INFRASTRUCTURE"
                    echo "======================================"

                    cd terraform

                    terraform init -input=false
                    terraform fmt -check
                    terraform validate
                    terraform plan -input=false

                    echo
                    echo "===== TERRAFORM CHECK SUCCESSFUL ====="
                '''
            }
        }

        stage('Deployment Approval') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: 'Approve Kafka deployment?', ok: 'Deploy Kafka'
                }
            }
        }

        stage('Kafka Deployment - Shared Library') {
            steps {
                kafkaDeploy(
                    ansibleDir: 'ansible',
                    inventory: 'inventory.ini',
                    playbook: 'site.yml'
                )
            }
        }

        stage('Kafka Functional Test') {
            steps {
                sh '''
                    echo "======================================"
                    echo "       KAFKA FUNCTIONAL TEST"
                    echo "======================================"

                    for host in "$KAFKA1" "$KAFKA2"; do
                        echo
                        echo "Testing Kafka broker: $host"

                        ssh -i /var/lib/jenkins/.ssh/one-click-kafka-key \
                          -o BatchMode=yes \
                          -o StrictHostKeyChecking=no \
                          ubuntu@$host \
                          "sudo /opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server $host:9092 | head -5"
                    done

                    echo
                    echo "===== KAFKA FUNCTIONAL TEST PASSED ====="
                '''
            }
        }

        stage('Kafka Health Check - Shared Library') {
            steps {
                kafkaHealthCheck([
                    env.KAFKA1,
                    env.KAFKA2
                ])
            }
        }

        stage('Kafka DR Backup - Shared Library') {
            steps {
                kafkaDrBackup([
                    env.KAFKA1,
                    env.KAFKA2
                ])
            }
        }
    }

    post {
        success {
            echo '✅ KAFKA DEPLOYMENT SUCCESSFUL'
        }

        failure {
            echo '❌ KAFKA DEPLOYMENT FAILED'
        }

        always {
            echo "Build completed: ${env.BUILD_NUMBER}"
        }
    }
}
