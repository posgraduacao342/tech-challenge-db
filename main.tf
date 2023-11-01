provider "aws" {
  region = "us-east-1"
}

variable "db_username" {
  description = "Username for the database"
}

variable "db_password" {
  description = "Password for the database"
}

resource "aws_db_instance" "postgresql_instance" {
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "postgres"
    engine_version       = "13.1"
    instance_class       = "db.t3.micro"
    db_name              = "postgres"
    username             = var.db_username
    password             = var.db_password
}
