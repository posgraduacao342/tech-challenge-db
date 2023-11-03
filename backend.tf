terraform {
  backend "s3" {
    bucket = "terraform-vpc-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}