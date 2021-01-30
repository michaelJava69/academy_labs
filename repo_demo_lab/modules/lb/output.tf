output "alb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "The domain name of the loadbalancer"
}

output "target_group_arn" {
   value = aws_lb_target_group.pool.arn

}


