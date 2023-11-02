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

variable "vpc_id" {
  description = "ID da VPC"
}

variable "vpc_ips" {
  description = "ID da VPC"
}

resource "aws_security_group" "database_access" {
  name        = "allow-database-access"
  description = "Security group to allow database access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_ips]
  }

  tags = {
    Name = "database_access"
  }
}

resource "aws_db_instance" "postgresql_instance" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "15.3"
  instance_class    = "db.t3.micro"
  db_name           = "postgres"
  username          = var.db_username
  password          = var.db_password
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.database_access.id]
}
