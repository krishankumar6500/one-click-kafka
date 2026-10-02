# One-Click Kafka Terraform

Terraform manages and validates the AWS infrastructure used by the
One-Click Apache Kafka project.

Current implementation reads the existing Jenkins and Kafka infrastructure
without modifying or destroying running resources.

Region: ap-south-1

Components:
- Jenkins EC2
- Kafka Broker 1
- Kafka Broker 2
- VPC
- Subnet
- Jenkins Security Group
- Kafka Security Group
