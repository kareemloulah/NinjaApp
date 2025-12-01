output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "master_public_ip" {
  description = "Master node public IP"
  value       = aws_instance.master.public_ip
}

output "master_private_ip" {
  description = "Master node private IP"
  value       = aws_instance.master.private_ip
}

output "worker_public_ips" {
  description = "Worker nodes public IPs"
  value       = aws_instance.worker[*].public_ip
}

output "worker_private_ips" {
  description = "Worker nodes private IPs"
  value       = aws_instance.worker[*].private_ip
}

output "master_ssh_command" {
  description = "SSH command for master node"
  value       = "ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.master.public_ip}"
}

output "worker_ssh_commands" {
  description = "SSH commands for worker nodes"
  value = [
    for idx, instance in aws_instance.worker :
    "ssh -i ${var.ssh_key_path} ubuntu@${instance.public_ip}"
  ]
}

output "cluster_info" {
  description = "Kubernetes cluster information"
  value = <<-EOT
    
    ─────────────────────────────────────────────────────────────
    
    K8s Cluster Deployed Successfully!
    
    Master Node:  ${aws_instance.master.public_ip} (${aws_instance.master.private_ip})
    Worker Node 1: ${aws_instance.worker[0].public_ip} (${aws_instance.worker[0].private_ip})
    Worker Node 2: ${aws_instance.worker[1].public_ip} (${aws_instance.worker[1].private_ip})
    
    ─────────────────────────────────────────────────────────────
    
    Access Your Cluster

    
    SSH to master:
      ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.master.public_ip}
    
    Check cluster status:
      kubectl get nodes
      kubectl get pods -A
    
    ─────────────────────────────────────────────────────────────
    
    Pre-configured Namespaces
    
    • vprofile  - For application deployments
    • monitoring - For Prometheus & Grafana
    
    ─────────────────────────────────────────────────────────────
    
    Copy kubeconfig to Local Machine
    
    ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.master.public_ip} 'sudo cat /etc/kubernetes/admin.conf' > ~/.kube/config
    
    # Then use SSH tunnel to access:
    ssh -i ${var.ssh_key_path} -L 6443:localhost:6443 ubuntu@${aws_instance.master.public_ip} -N &
    sed -i 's|https://.*:6443|https://localhost:6443|g' ~/.kube/config
    kubectl get nodes
    
  EOT
}

output "quick_commands" {
  description = "Quick access commands"
  value = {
    ssh_master     = "ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.master.public_ip}"
    ssh_worker_1   = "ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.worker[0].public_ip}"
    ssh_worker_2   = "ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.worker[1].public_ip}"
    get_kubeconfig = "ssh -i ${var.ssh_key_path} ubuntu@${aws_instance.master.public_ip} 'sudo cat /etc/kubernetes/admin.conf' > ~/.kube/config"
  }
}
