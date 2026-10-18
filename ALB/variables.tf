variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
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

variable "ssl_policy" {
  description = "The SSL policy for the ALB"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for the ALB"
  type        = string
}