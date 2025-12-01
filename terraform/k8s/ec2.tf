# Data source for Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Master Node
resource "aws_instance" "master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.master.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/scripts/master-user-data.sh", {
    node_type = "master"
  })

  tags = {
    Name    = "${var.project_name}-master"
    Role    = "master"
    Project = var.project_name
  }
}

# Worker Nodes
resource "aws_instance" "worker" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.worker.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/scripts/worker-user-data.sh", {
    node_type   = "worker"
    worker_id   = count.index + 1
    master_ip   = aws_instance.master.private_ip
  })

  depends_on = [aws_instance.master]

  tags = {
    Name    = "${var.project_name}-worker-${count.index + 1}"
    Role    = "worker"
    Project = var.project_name
  }
}
