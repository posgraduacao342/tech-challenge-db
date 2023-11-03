resource "aws_s3_bucket" "remote_state" {
  bucket = "terraform-db-state"

  tags = {
    description = "Terraform data-base infrastructure remote state files storing"
    name = "terraform-db-state"
  }
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}