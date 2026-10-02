pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        ANSIBLE_DIR = 'ansible'
        INVENTORY   = 'ansible/inventory.ini'
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

        stage('Ansible Syntax Check') {
            steps {
                sh '''
                    cd "$ANSIBLE_DIR"
                    ansible-playbook \
                      -i inventory.ini \
                      site.yml \
                      --syntax-check
                '''
            }
        }

        stage('Kafka Deployment') {
            steps {
                sh '''
                    cd "$ANSIBLE_DIR"

                    ansible-playbook \
                      -i inventory.ini \
                      site.yml
                '''
            }
        }

        stage('Kafka Health Check') {
            steps {
                sh '''
                    echo "===== KAFKA HEALTH CHECK ====="

                    ssh -i /var/lib/jenkins/.ssh/one-click-kafka-key \
                      -o BatchMode=yes \
                      -o StrictHostKeyChecking=no \
                      ubuntu@172.31.27.172 \
                      "sudo systemctl is-active kafka"

                    ssh -i /var/lib/jenkins/.ssh/one-click-kafka-key \
                      -o BatchMode=yes \
                      -o StrictHostKeyChecking=no \
                      ubuntu@172.31.20.48 \
                      "sudo systemctl is-active kafka"

                    echo "===== BOTH KAFKA NODES HEALTHY ====="
                '''
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
