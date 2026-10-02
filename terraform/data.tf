# Existing One-Click Kafka infrastructure
# Terraform reads the infrastructure without modifying it.

data "aws_vpc" "main" {
  id = "vpc-0ed88de4f3d0b0cff"
}

data "aws_subnet" "main" {
  id = "subnet-0a291e37a12e4150b"
}

data "aws_security_group" "jenkins" {
  id = "sg-028154503c9d183c8"
}

data "aws_security_group" "kafka" {
  id = "sg-03a01ef7daa2ab106"
}

data "aws_instance" "jenkins" {
  instance_id = "i-06eaaeaf81edf485f"
}

data "aws_instance" "kafka1" {
  instance_id = "i-0f56d6f858ead3978"
}

data "aws_instance" "kafka2" {
  instance_id = "i-02671f105634583da"
}
