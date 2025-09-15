# 🛠️ Enterprise DevOps Pipeline: Jenkins, Terraform, Ansible & Docker

[![Pipeline Stages](https://img.shields.io/badge/Pipeline-3%20Stages-brightgreen)](#pipeline-overview)  
[![IaC](https://img.shields.io/badge/IaC-Terraform-orange)](#infrastructure-as-code)  
[![Config Mgmt](https://img.shields.io/badge/Config-Ansible-red)](#configuration-management)  
[![Containers](https://img.shields.io/badge/Containers-Docker-blue)](#containerization)  
[![Automation](https://img.shields.io/badge/Automation-Jenkins-yellow)](#automation)

> **A fully automated CI/CD solution that provisions ephemeral infrastructure, deploys containerized apps, and manages cleanup—all in a production-grade workflow.**

---

## 🌐 Project Synopsis

This project demonstrates a **3-stage CI/CD pipeline** designed to replicate modern DevOps workflows, using AWS, Jenkins, Terraform, Ansible, and Docker. Perfect for hands-on experience in **infrastructure provisioning, application deployment, and maintenance automation**.  

### ✨ Key Highlights

- **Ephemeral Infrastructure** – Spin up and destroy EC2s dynamically.  
- **IaC with Terraform** – Remote state and version-controlled infrastructure.  
- **Automated Configuration** – Ansible scripts for server setup.  
- **Docker Deployment** – Build, tag, and push images to a private registry.  
- **Scheduled Cleanup** – Daily automated teardown of test environments.  
- **Secure Practices** – No secrets in code; Jenkins credentials used.  

---

## 📊 Pipeline Overview

```mermaid
graph TD
    A[Git Push] --> B[Pipeline 1: Provision & Configure]
    B --> C[Pipeline 2: Build & Deploy]
    D[Scheduled Cron] --> E[Pipeline 3: Cleanup]

    B --> F[Terraform Apply]
    F --> G[Launch EC2 Instances]
    G --> H[Ansible Docker Setup]
    H --> I[Store Info in SSM]

    C --> J[Docker Image Build]
    J --> K[Push to Private Registry]
    K --> L[Deploy via SSH]
    L --> M[Run Health Checks]

    E --> N[Discover Ephemeral Instances]
    N --> O[Terminate Instances]
    O --> P[Log Cleanup]
CI-CD-Pipeline/
├── Jenkinsfile.provision    # Stage 1: Infra provisioning
├── Jenkinsfile.deploy       # Stage 2: Build & deploy
├── Jenkinsfile.cleanup      # Stage 3: Automated cleanup
├── terraform/               # Terraform configs
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
└── ansible/                 # Ansible playbooks
    └── playbook.yml         # Docker setup automation

📂 Repository Layout
CI-CD-Pipeline/
├── Jenkinsfile.provision    # Stage 1: Infra provisioning
├── Jenkinsfile.deploy       # Stage 2: Build & deploy
├── Jenkinsfile.cleanup      # Stage 3: Automated cleanup
├── terraform/               # Terraform configs
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
└── ansible/                 # Ansible playbooks
    └── playbook.yml         # Docker setup automation

⚡ Getting Started
Beginner Setup

Clone the repository

git clone <your-repo-url>
cd CI-CD-Pipeline


Add Jenkins Credentials

aws-creds → AWS keys

docker-creds → Docker Hub credentials

jenkins-key → EC2 SSH key

cleanup-creds → AWS credentials for teardown

Configure Jenkins Jobs

Provision Job → Jenkinsfile.provision

Deployment Job → Jenkinsfile.deploy

Cleanup Job → Jenkinsfile.cleanup (Cron: TZ=Africa/Cairo 0 0 * * *)

Run the Pipeline

Push to main → Watch the automated workflow execute.

Intermediate Customization

Terraform Remote Backend

aws s3 mb s3://terraform-state-bucket
aws dynamodb create-table --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5


Variables

variable "aws_region" { default = "us-east-1" }
variable "instance_type" { default = "t2.micro" }


Pipeline Tweaks

Change Docker image tags

Adjust retries and error handling

Modify cleanup schedule

Add notifications

Advanced / Enterprise Level

Multi-environment support: dev, staging, prod

Secure infrastructure: minimal IAM permissions, encrypted S3 states

Monitoring & metrics: CloudWatch + automated health checks

Advanced deployment strategies: Blue/Green, Canary releases

🔧 Technical Breakdown
Stage 1 – Provision & Configure

Creates ephemeral EC2 instances

Configures servers via Ansible

Stores instance info in AWS SSM

Terraform remote state with S3 + DynamoDB

Stage 2 – Build & Deploy

Builds Docker images

Pushes to private registry

Deploys containers via SSH

Performs automated health checks

Stage 3 – Cleanup

Runs daily at 12:00 AM Cairo time

Terminates all ephemeral instances

Logs all operations for audit purposes

🔐 Security

No Secrets in Code – Use Jenkins credentials

Least Privilege – AWS IAM roles scoped for tasks

Encrypted Storage – S3 state files encrypted

Minimal Ports – Tightened security groups

📈 Monitoring

Track Jenkins build status

EC2 instance metrics via CloudWatch

Deployment verification through automated tests

Cleanup logs for audit & reporting

🛠️ Troubleshooting

Terraform state lock: terraform force-unlock <lock-id>

SSH timeout: Check security groups & instance status

Docker login fails: echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

Cleanup fails: Manually terminate instances using AWS CLI

🎓 Learning Outcomes

Beginner: CI/CD basics, automation, Docker fundamentals
Intermediate: Terraform & Ansible best practices, Docker registry usage
Expert: Enterprise security, scalable deployments, monitoring & optimization

🤝 Contributing

Fork the repo

Create a branch git checkout -b feature/my-feature

Commit your changes git commit -m "Add feature"

Push branch git push origin feature/my-feature

Open a Pull Request

📌 Roadmap

Multi-cloud support (Azure & GCP)

Kubernetes integration

Prometheus + Grafana dashboards

Security scans (SAST/DAST)

Load testing automation

📚 Resources

Jenkins Pipeline Docs

Terraform AWS Provider

Ansible AWS Modules

Docker Best Practices