# One-Click Apache Kafka Deployment

Automated Apache Kafka 3.9.2 deployment using:

- Jenkins
- Git/GitHub
- Terraform
- Ansible
- Ansible Role
- Jinja2
- Apache Kafka 3.9.2
- KRaft
- Systemd
- SSH
- HA validation
- Health checks
- Slack/Email notifications

## Architecture

GitHub → Jenkins → Terraform → Ansible → Kafka-1 + Kafka-2 → Verification → Notification
