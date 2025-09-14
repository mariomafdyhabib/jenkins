variable "aws_region" { type = string }
variable "ami_id"     { type = string }
variable "instance_type" { type = string, default = "t3.micro" }
variable "key_name"   { type = string } # existing keypair name
