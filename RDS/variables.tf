variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "database_subnet_ids" {
  description = "A list of database subnet IDs"
  type        = list(string)
}

variable "private_ec2_sg_id" {
  description = "The ID of the private EC2 security group"
  type        = string
}

variable "secret_name" {
  description = "The name of the secret in AWS Secrets Manager for the RDS database credentials"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage size for the RDS instance in GB"
  type        = number
}

variable "engine" {
  description = "The database engine for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create when the RDS instance is created"
  type        = string
}

variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate with the RDS instance"
  type        = string
}

variable "parameter_group_family" {
  description = "The family of the DB parameter group to associate with the RDS instance"
  type        = string
}