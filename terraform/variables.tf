variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"

}

variable "instance_type" {
  description = "The type of instance to use for the EC2 instance"
  type        = string
  default     = "t2.micro"

}

resource "aws_vpc" "ci_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ci_subnet" {
  vpc_id     = aws_vpc.ci_vpc.id
  cidr_block = "10.0.1.0/24"
}