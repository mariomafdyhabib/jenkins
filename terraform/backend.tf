terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket"
    key            = "ci/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
