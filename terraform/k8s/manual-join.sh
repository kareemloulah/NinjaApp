#!/bin/bash
# Manual script to join workers to the cluster

MASTER_IP="3.227.247.178"
WORKER1_IP="3.235.156.24"
WORKER2_IP="54.86.231.114"
SSH_KEY="~/Downloads/test2.pem"

echo "Fetching join command from master..."
scp -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$MASTER_IP:/home/ubuntu/join-command.sh /tmp/k8s-join-command.sh

if [ ! -f /tmp/k8s-join-command.sh ]; then
  echo "❌ Failed to get join command. Master may still be initializing."
  echo "Check master logs:"
  echo "  ssh -i $SSH_KEY ubuntu@$MASTER_IP 'tail -f /var/log/k8s-master-init.log'"
  exit 1
fi

echo "✅ Join command retrieved!"
echo ""
echo "Joining Worker 1 ($WORKER1_IP)..."
scp -i $SSH_KEY -o StrictHostKeyChecking=no /tmp/k8s-join-command.sh ubuntu@$WORKER1_IP:/tmp/
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$WORKER1_IP 'sudo bash /tmp/k8s-join-command.sh'

echo ""
echo "Joining Worker 2 ($WORKER2_IP)..."
scp -i $SSH_KEY -o StrictHostKeyChecking=no /tmp/k8s-join-command.sh ubuntu@$WORKER2_IP:/tmp/
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$WORKER2_IP 'sudo bash /tmp/k8s-join-command.sh'

echo ""
echo "✅ Workers joined! Verifying cluster..."
sleep 10
ssh -i $SSH_KEY ubuntu@$MASTER_IP 'kubectl get nodes'
