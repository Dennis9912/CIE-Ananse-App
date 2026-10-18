output "cie_webserver_tg_arn" {
  value = aws_lb_target_group.cie_webserver_alb_tg.arn
}

output "alb_sg_id" {
  description = "Security group ID attached to the ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.cie_webserver_alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.cie_webserver_alb.zone_id
}