
# 🚀 NextShop EKS Infrastructure Setup — README

This guide walks you through setting up and destroying AWS EKS infrastructure for the **NextShop** project using Terraform, Docker, and kubectl.

---

## ✅ 1. Install Terraform (Windows 64-bit)

1. Download from: https://developer.hashicorp.com/terraform/downloads
2. Extract the `terraform.exe` to a known path.
3. Add it to your system `PATH` environment variable.
4. Verify:
```bash
terraform -v
```

---

## ✅ 2. AWS CLI Setup and Profile Configuration

### 🔹 Install AWS CLI
Download from: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html

### 🔹 Configure a Profile
Use IAM user credentials:
```bash
aws configure --profile nextshop
```
You'll be asked for:
- AWS Access Key ID
- AWS Secret Access Key
- Region (e.g., us-east-1)
- Output format: json

To confirm:
```bash
aws sts get-caller-identity --profile nextshop
```

---

## ✅ 3. Terraform Project Files Structure

Ensure the following files are present:

```
nextshop-infra/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── vpc.tf
├── eks-cluster.tf
├── node-group.tf
├── iam.tf
└── versions.tf
```

---

## ✅ 4. Terraform Commands to Provision Infrastructure

### 🔹 Initialize Terraform
```bash
terraform init
```

### 🔹 Validate Configuration
```bash
terraform validate
```

### 🔹 Review Execution Plan
```bash
terraform plan
```

### 🔹 Apply and Create Infrastructure
```bash
export AWS_PROFILE=nextshop
terraform apply --auto-approve
```

---

## ✅ 5. Docker + ECR Setup

### 🔹 Build Docker Image
```bash
docker build -t nextshop-auth-service .
```

### 🔹 Tag Docker Image
```bash
docker tag nextshop-auth-service:latest <account_id>.dkr.ecr.us-east-1.amazonaws.com/nextshop-auth-service:latest
```

### 🔹 Authenticate Docker to ECR
```bash
aws ecr get-login-password --region us-east-1 --profile nextshop | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com
```

### 🔹 Push to ECR
```bash
docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/nextshop-auth-service:latest
```

---

## ✅ 6. Deploy to EKS Using kubectl

### 🔹 Configure Kubeconfig
```bash
aws eks --region us-east-1 update-kubeconfig --name nextshop --profile nextshop
```

### 🔹 Apply Deployment and Service YAML
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 🔹 View Pods and Services
```bash
kubectl get pods
kubectl get svc
kubectl logs <pod-name>
```
### 🔹 View Pods and Services
```bash
 access auth service using posman:
  http://<external-ip>/api/auth/signup
     note : get the external-ip after running kubectl get svc cmd

---

## ✅ 7. Terraform Destroy (Clean-Up)

### 🔹 Destroy Infrastructure
```bash
export AWS_PROFILE=nextshop
terraform destroy --auto-approve
```

---

## 🧼 Optional: Clean Local Files
```bash
rm -rf .terraform terraform.tfstate terraform.tfstate.backup
```

---

Happy Deploying! 🛠️
