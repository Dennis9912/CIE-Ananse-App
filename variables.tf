variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}

variable "database_subnet_cidr_blocks" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
}

variable "image_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
}

variable "r53_zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the Route 53 record"
  type        = string
}

variable "ssl_policy" {
  description = "The SSL policy for the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for the ALB"
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