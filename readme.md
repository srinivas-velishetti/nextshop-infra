
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

----------------------------------------------------------
# 💣 NextShop Infra — Full Destroy Commands Guide

This guide contains step-by-step instructions and commands to **safely and completely destroy all AWS infrastructure** provisioned for the NextShop project using Terraform, AWS CLI, and kubectl.

---

## ⚠️ Prerequisites

- Terraform and AWS CLI installed
- AWS profile (e.g., `nextshop`) properly configured
- EKS cluster and resources created previously

---

## ✅ Step 1: Export AWS Profile

```bash
export AWS_PROFILE=nextshop
export AWS_REGION=us-east-1
```

---

## 🔍 Step 2: Check Running Resources

### 🔹 EC2 Instances

```bash
aws ec2 describe-instances --query "Reservations[*].Instances[*].State.Name" --region $AWS_REGION --profile $AWS_PROFILE
```

### 🔹 EKS Clusters

```bash
aws eks list-clusters --region $AWS_REGION --profile $AWS_PROFILE
```

---

## 🧹 Step 3: Clean Up EKS Dependencies

### 🔹 Delete EKS Node Groups (if any)

```bash
aws eks list-nodegroups --cluster-name nextshop --region $AWS_REGION --profile $AWS_PROFILE
aws eks delete-nodegroup --cluster-name nextshop --nodegroup-name <nodegroup-name> --region $AWS_REGION --profile $AWS_PROFILE
```

### 🔹 Delete EKS Cluster

```bash
aws eks delete-cluster --name nextshop --region $AWS_REGION --profile $AWS_PROFILE
```

---

## 🚫 Step 4: Delete Load Balancers

```bash
aws elbv2 describe-load-balancers --region $AWS_REGION --profile $AWS_PROFILE

# Delete each
aws elbv2 delete-load-balancer --load-balancer-arn <lb-arn> --region $AWS_REGION --profile $AWS_PROFILE
```

---

## 🔌 Step 5: Delete Elastic IPs

```bash
aws ec2 describe-addresses --region $AWS_REGION --profile $AWS_PROFILE
aws ec2 release-address --allocation-id <eip-id> --region $AWS_REGION --profile $AWS_PROFILE
```

---

## 🌐 Step 6: Delete Network Interfaces (ENIs)

```bash
aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=<vpc-id>" --region $AWS_REGION --profile $AWS_PROFILE
aws ec2 delete-network-interface --network-interface-id <eni-id> --region $AWS_REGION --profile $AWS_PROFILE
```

---

## 🗑️ Step 7: Terraform Destroy

```bash
cd nextshop-infra
terraform destroy --auto-approve
```

---

## 🧼 Step 8: Clean Local Terraform Files

```bash
rm -rf .terraform terraform.tfstate terraform.tfstate.backup
```

---

## ✅ All Infra Cleaned!

Make sure nothing is left:
```bash
aws ec2 describe-vpcs --region $AWS_REGION --profile $AWS_PROFILE
aws eks list-clusters --region $AWS_REGION --profile $AWS_PROFILE
aws ec2 describe-addresses --region $AWS_REGION --profile $AWS_PROFILE
```

---

🔥 Done! All resources from NextShop Infra should now be destroyed and billing-safe.