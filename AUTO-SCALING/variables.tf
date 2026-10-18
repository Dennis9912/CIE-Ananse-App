variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
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

variable "public_subnet_az_1a_id" {
  description = "The ID of the public subnet in availability zone 1a"
  type        = string
}

variable "public_subnet_az_1b_id" {
  description = "The ID of the public subnet in availability zone 1b"
  type        = string
}

# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
# }

variable "cie_webserver_tg_arn" {
  description = "The ARN of the target group for the ALB"
  type        = string
}

variable "alb_sg_id" {
  description = "The ID of the security group for the ALB"
  type        = string
}