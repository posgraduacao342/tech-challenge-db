provider "aws" {
  region = "us-east-1"
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_instance" "postgresql_instance" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "15.2"
  instance_class    = "db.t3.micro"
  db_name           = "postgres"
  username          = var.db_username
  password          = var.db_password
}
