output "aws_ami_id" {

   value = data.aws_ami.amazonlinux

}


output "alb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "The domain name of the loadbalancer"
}

/*
output "aws_ami_ids" {
   value = data.aws_ami_ids.ids.ids

}
*/
