output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "subnet_id" {
  value = data.aws_subnet.main.id
}

output "jenkins_instance_id" {
  value = data.aws_instance.jenkins.id
}

output "jenkins_private_ip" {
  value = data.aws_instance.jenkins.private_ip
}

output "kafka1_instance_id" {
  value = data.aws_instance.kafka1.id
}

output "kafka1_private_ip" {
  value = data.aws_instance.kafka1.private_ip
}

output "kafka2_instance_id" {
  value = data.aws_instance.kafka2.id
}

output "kafka2_private_ip" {
  value = data.aws_instance.kafka2.private_ip
}

output "kafka1_instance_type" {
  value = data.aws_instance.kafka1.instance_type
}

output "kafka2_instance_type" {
  value = data.aws_instance.kafka2.instance_type
}
