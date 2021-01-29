output "alb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "The domain name of the loadbalancer"
}




