output "alb_dns_name" {
  value       = "${module.prod-lb.alb_dns_name}"
  description = "The domain name of the loadbalancer"
}
