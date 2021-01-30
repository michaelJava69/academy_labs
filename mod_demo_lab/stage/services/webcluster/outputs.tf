output "alb_dns_name" {
  value       = "${module.stage-lb.alb_dns_name}"
  description = "The domain name of the loadbalancer"
}
