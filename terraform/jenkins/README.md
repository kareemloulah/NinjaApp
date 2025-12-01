<h3 align="center"> Jenkins Infrastructure </h3>

### Initialize Terraform

```bash
cd terraform/jenkins
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

### get initialAdminPassword

```bash
ssh -i ~/Downloads/test2.pem ubuntu@44.223.83.78
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Cleanup

```bash
terraform destroy -auto-approve
```
