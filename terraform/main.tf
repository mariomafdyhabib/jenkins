terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC
resource "aws_vpc" "ci_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "ci_subnet" {
  vpc_id     = aws_vpc.ci_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Internet Gateway
resource "aws_internet_gateway" "ci_igw" {
  vpc_id = aws_vpc.ci_vpc.id
}

# Route Table
resource "aws_route_table" "ci_route_table" {
  vpc_id = aws_vpc.ci_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ci_igw.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "ci_subnet_assoc" {
  subnet_id      = aws_subnet.ci_subnet.id
  route_table_id = aws_route_table.ci_route_table.id
}

# Security Group to allow SSH
resource "aws_security_group" "ci_sg" {
  name        = "ci_sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.ci_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict to Jenkins IP if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ci_ephemeral" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "Jenkins"
  subnet_id                   = aws_subnet.ci_subnet.id
  vpc_security_group_ids      = [aws_security_group.ci_sg.id]

  tags = {
    Name     = "ci-ephemeral"
    lifespan = "ephemeral"
    owner    = "jenkins"
  }
}

# Store Public IP in SSM Parameter Store
resource "aws_ssm_parameter" "ci_ephemeral_ip" {
  name  = "/jenkins/ci_ephemeral_ip"
  type  = "String"
  value = aws_instance.ci_ephemeral.public_ip
}

