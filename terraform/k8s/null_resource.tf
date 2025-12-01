# Null resource to automate worker joining
resource "null_resource" "join_workers" {
  depends_on = [
    aws_instance.master,
    aws_instance.worker
  ]

  # Trigger on master or worker changes
  triggers = {
    master_id  = aws_instance.master.id
    worker_ids = join(",", aws_instance.worker[*].id)
  }

  # Wait for master initialization and join workers
  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for master node initialization (this takes ~3-5 minutes)..."
      sleep 180
      
      echo "Checking if master is ready..."
      ssh -i ${var.ssh_key_path} -o StrictHostKeyChecking=no ubuntu@${aws_instance.master.public_ip} \
        'tail -20 /var/log/k8s-master-init.log' || echo "Master still initializing..."
      
      echo "Fetching join command from master..."
      max_attempts=10
      attempt=0
      while [ $attempt -lt $max_attempts ]; do
        if scp -i ${var.ssh_key_path} -o StrictHostKeyChecking=no \
          ubuntu@${aws_instance.master.public_ip}:/home/ubuntu/join-command.sh /tmp/k8s-join-command.sh 2>/dev/null; then
          echo "Join command retrieved successfully!"
          break
        fi
        attempt=$((attempt + 1))
        echo "Attempt $attempt/$max_attempts: Waiting for join command..."
        sleep 30
      done
      
      if [ ! -f /tmp/k8s-join-command.sh ]; then
        echo "Failed to retrieve join command. Please join workers manually."
        exit 0
      fi
      
      echo "Joining worker nodes..."
      for worker_ip in ${join(" ", aws_instance.worker[*].public_ip)}; do
        echo "Joining worker at $worker_ip..."
        scp -i ${var.ssh_key_path} -o StrictHostKeyChecking=no \
          /tmp/k8s-join-command.sh ubuntu@$worker_ip:/tmp/ || continue
        ssh -i ${var.ssh_key_path} -o StrictHostKeyChecking=no \
          ubuntu@$worker_ip 'sudo bash /tmp/k8s-join-command.sh' || echo "Worker $worker_ip join failed, retry manually"
      done
      
      echo "Cluster setup complete! Verifying nodes..."
      sleep 30
      ssh -i ${var.ssh_key_path} -o StrictHostKeyChecking=no \
        ubuntu@${aws_instance.master.public_ip} 'kubectl get nodes' || echo "Run 'kubectl get nodes' on master to verify"
    EOT
  }
}
