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