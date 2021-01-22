output "alb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "The domain name of the loadbalancer"
}


output "echo" {

   value  = data.external.echo.result
}

output "echo_foo" {
    value = data.external.echo.result.foo
}


output "splat_example_id"  {

   value = aws_instance.instance2[*].id
}

output "splat_example_public_ip"  {

   value = aws_instance.instance2[*].public_ip
}
