
variable  "user_names" {
    description = "Create IAM Users  with these names"
    type = list(string)
    default  =  ["neo","michael", "jane"]

}

variable  "user_names2" {
    description = "Create IAM Users  with these names"
    type = list(string)
    default =  ["neo2","michael2", "jane2"]

}

#### count

resource "aws_iam_user"  "example" {
   count = length(var.user_names)
   name = var.user_names[count.index]
}



##### for_each

resource "aws_iam_user"  "example2" {
   for_each = toset(var.user_names2)
   name = each.value                    ## becuase this was a list each.key also contanins the name  
}                                       ## mulitple copies of resource created




##  using for_each
resource "aws_instance" "ec2"  {

  
  ami = data.aws_ami.amazonlinux.image_id
  instance_type = "t2.micro"
  
  ## for_each = toset(data.aws_availability_zones.azs.names)
  ##   availability_zone = each.value

/*
  for_each = {
       for key, value in local.myfilter2 :
       key => value
  }
 */

  for_each = local.myfilter2


  availability_zone = each.value 

  tags ={
    name = "apache-server-${each.key}"
  }

}



resource "aws_subnet" "sub"  {

    for_each = {us-east-2a="172.20.10.0/24",us-east-2b="172.20.20.0/24",us-east-2c="172.20.30.0/24"}

    cidr_block = each.value
    vpc_id = "123456"
    availability_zone = each.key

    tags = {
       zone = "subnet-${each.key}
    }
}



/*

## using count
resource "aws_instance" "ec2"  {

  count = 3
  ami = data.aws_ami.amazonlinux.image_id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  
  tags ={
    name = "apache-server-${count.index}"
  }

}

*/


locals {
    myfilter2 =     {web_server1 ="us-east-2a", web_server2 ="us-east-2b", web_server3 ="us-east-2c"}
}


###---------------------------------------------------------------------------------------------------------------------

/*

# aws_instance.ec2[2] will be created
  + resource "aws_instance" "ec2" {
      + ami                          = "ami-0a0ad6b70e61be944"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "name" = "apache-server-2"
        }

*/
