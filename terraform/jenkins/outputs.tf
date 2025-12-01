output "jenkins_public_ip" {
  description = "Public IP address of Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}

output "jenkins_private_ip" {
  description = "Private IP address of Jenkins server"
  value       = aws_instance.jenkins_server.private_ip
}

output "jenkins_instance_id" {
  description = "Instance ID of Jenkins server"
  value       = aws_instance.jenkins_server.id
}

output "jenkins_url" {
  description = "Jenkins Web UI URL"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "jenkins_ssh_command" {
  description = "SSH command to connect to Jenkins server"
  value       = "ssh -i ~/Downloads/test2.pem ubuntu@${aws_instance.jenkins_server.public_ip}"
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.jenkins_vpc.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.jenkins_public_subnet.id
}

output "security_group_id" {
  description = "Security group ID for Jenkins"
  value       = aws_security_group.jenkins_sg.id
}
