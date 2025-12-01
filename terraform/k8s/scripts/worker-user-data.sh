#!/bin/bash
set -e

# Base node setup
cat > /tmp/init-node.sh << 'EOFBASE'
#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/k8s-init.log)
exec 2>&1

echo "Starting Kubernetes node initialization..."

# Update system
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load kernel modules
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Set sysctl params
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# Install containerd
apt-get install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y containerd.io

# Configure containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Install kubeadm, kubelet, kubectl
apt-get install -y apt-transport-https
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

echo "Node initialization completed successfully!"
EOFBASE

chmod +x /tmp/init-node.sh
/tmp/init-node.sh

# Worker-specific setup
cat > /tmp/init-worker.sh << 'EOFWORKER'
#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/k8s-worker-init.log)
exec 2>&1

echo "Worker node ready. Waiting for join command from master..."
echo "To join this worker to the cluster, SSH to master and run:"
echo "  scp /home/ubuntu/join-command.sh ubuntu@$(hostname -I | awk '{print $1}'):/tmp/"
echo "  ssh ubuntu@$(hostname -I | awk '{print $1}') 'sudo bash /tmp/join-command.sh'"
EOFWORKER

chmod +x /tmp/init-worker.sh
/tmp/init-worker.sh
