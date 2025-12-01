<h3 align="center"> K8s Cluster Infrastructure </h3>

### Initialize Terraform

```bash
cd terraform/k8s
terraform init
```

### plan

```bash
terraform plan
```

### Deploy Everything

```bash
terraform apply -auto-approve
```

### output

```bash
terraform output
```

### refresh

if you update the tf code

```bash
terraform refresh
```

### Access Your Cluster

```bash
# SSH to master
ssh -i ~/Downloads/test2.pem ubuntu@<master-ip>
ssh -i ~/Downloads/test2.pem ubuntu@3.234.229.182

```

### Verify Cluster

```bash
kubectl get nodes
kubectl get pods -A
kubectl get namespaces
```

### Cleanup

```bash
terraform destroy -auto-approve
```

---

### Copy kubeconfig to Local Machine (optional)

backup old config

```bash
cd ~/.kube
config config.backup
```

get the update command for the kube config
```bash
terraform output quick_commands
```

for me here's the command

```bash
ssh -i ~/Downloads/test2.pem ubuntu@3.234.229.182 'sudo cat /etc/kubernetes/admin.conf' > ~/.kube/config
```
