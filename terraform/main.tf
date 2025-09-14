# terraform/main.tf (minimal)
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ci_ephemeral" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name     = "ci-ephemeral"
    owner    = "jenkins"
    lifespan = "ephemeral"
  }
}

output "public_ip" {
  value = aws_instance.ci_ephemeral.public_ip
}
