# Create R53 - Simple Routing policy
resource "aws_route53_record" "www" {
  zone_id = var.r53_zone_id # Replace with your Route 53 hosted zone ID
  name    = var.domain_name # Replace with your domain name
  type    = "A"

  alias {
    name                   = var.alb_dns_name # Replace with your ALB DNS name
    zone_id                = var.alb_zone_id  # Replace with your ALB hosted zone ID
    evaluate_target_health = true
  }
}