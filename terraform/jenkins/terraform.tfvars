# AWS config
aws_region        = "us-east-1"
availability_zone = "us-east-1a"

# Project config
project_name = "vprofile-jenkins"
environment  = "production"

# Network config
vpc_cidr           = "10.1.0.0/16"
public_subnet_cidr = "10.1.1.0/24"

# EC2 config
jenkins_instance_type = "t3.micro"  # Free tier eligible (2 vCPU, 1GB RAM)
jenkins_volume_size   = 30
key_name              = "test2"

# Security config
trusted_ip_ranges = ["0.0.0.0/0"] # Allaw all
