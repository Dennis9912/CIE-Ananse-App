variable "r53_zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the Route 53 record"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "The hosted zone ID of the ALB"
  type        = string
}