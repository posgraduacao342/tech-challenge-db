resource "aws_s3_bucket" "remote_state" {
  bucket = "terraform-rds-state"

  tags = {
    description = "Terraform RDS data base infrastructure remote state files storing"
    name        = "terraform-rds-state"
  }
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}