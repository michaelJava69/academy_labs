
/*

output "alb_dns_name" {
  value = aws_lb.nlb.dns_name
  description = "The domain name of the loadbalancer"
}


*/


output "echo" {

  value = data.external.echo.result
}

output "echo_foo" {

  value = data.external.echo.result.foo

}

output "publicip" {
  value = aws_instance.instance.public_ip

}

# vpic id

output "vpc_id" {
  value = data.aws_vpc.default.id
}


# vpc id of existing vpc in cidr block 172.20.0.0/16

output "vpc_id_exist" {
  value = data.aws_vpc.exist.id
}


# vpc id state of existing vpc in cidr block 172.20.0.0/16

output "vpc_id_exist_state" {
  value = data.aws_vpc.exist.state
}



# image of ami image using

output "data_image" {
  value = data.aws_ami.amazonlinux.id
}


## instances map

output "t2_instances_map" {

  value = data.aws_ec2_instance_type_offerings.t2

}

## instances types

output "t2_instance_types" {

  value = data.aws_ec2_instance_type_offerings.t2.instance_types

}

