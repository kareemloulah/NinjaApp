# Jenkins EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jenkins_instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.jenkins_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.jenkins_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  user_data = file("${path.module}/scripts/jenkins-setup.sh")

  tags = {
    Name        = "${var.project_name}-jenkins-server"
    Environment = var.environment
    Project     = var.project_name
    Role        = "Jenkins"
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}
