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

variable "role_arn" {
  description = "Role"
}

variable "db_instance_name" {
  description = "Nome da instância do banco de dados"
  default     = "tech-challenge-db"
}

resource "aws_security_group" "database_access" {
  name        = "allow-database-access"
  description = "Security group to allow database access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database_access"
  }
}

resource "aws_db_instance" "postgresql_instance" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "15.3"
  instance_class      = "db.t3.micro"
  db_name             = "postgres"
  username            = var.db_username
  password            = var.db_password
  publicly_accessible = true
  identifier          = var.db_instance_name

  vpc_security_group_ids = [aws_security_group.database_access.id]
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "tech-challenge-db-secret-manager"
  description = "Secret for RDS database credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    "username" : var.db_username,
    "password" : var.db_password
  })
}

resource "aws_security_group" "db_proxy_sg" {
  name        = "tech-challenge-db-proxy-sg"
  description = "Security group for the RDS DB proxy"
  vpc_id      = var.vpc_id
}

resource "aws_subnet" "db_proxy_subnet" {
  count             = 2
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.0/16"
  availability_zone = "us-east-1a"
}

resource "aws_db_proxy" "db_proxy" {
  name                   = "tech-challenge-db-proxy"
  debug_logging          = false
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = var.role_arn
  vpc_security_group_ids = [aws_security_group.db_proxy_sg.id]
  vpc_subnet_ids         = aws_subnet.db_proxy_subnet[*].id

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.db_credentials.arn
  }
}