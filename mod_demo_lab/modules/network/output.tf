output "vpc-id" {

   value = aws_vpc.tfvpc.id 
}


output "alb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "The domain name of the loadbalancer"
}


output "aws_subnet-web1-id"  {

   value = aws_subnet.web1.id
}

output "aws_subnet-web2-id"  {

   value = aws_subnet.web2.id
}

output "target_group_arn" {
   value = aws_lb_target_group.pool.arn

}
