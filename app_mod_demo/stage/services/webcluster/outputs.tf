output "alb_dns_name" {
  value       = "${module.stage-network.alb_dns_name}"
  description = "The domain name of the loadbalancer"
}
