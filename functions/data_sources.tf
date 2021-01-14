data "aws_ec2_instance_type_offerings" "t2-type" {
  location_type = "region"

  filter {
    name = "instance-type"
    values = ["t2.*"]
  }
}


/*

With offerings need to converts set of strings to list first before delcting a member from list

> tolist(data.aws_ec2_instance_type_offerings.t2-type.instance_types)
[
  "t2.2xlarge",
  "t2.large",
  "t2.medium",
  "t2.micro",
  "t2.nano",
  "t2.small",
  "t2.xlarge",
]
> element(tolist(data.aws_ec2_instance_type_offerings.t2-type.instance_types),1)
t2.large

*/



##############
#  Pulling back images
#       Filtering on
#                    owner : amazon
#                    architecture : x86*
#                    name [aka AMI Name] = amzn2-ami-hvm-2.0*
#
#  Result = ami-0a0ad6b70e61be944
#####################################

data "aws_ami" "amazonlinux" {

  owners      = ["amazon"]
  most_recent = true

  dynamic "filter"{
    for_each = local.datafilter

    content {
      name = filter.value.name
      values = [filter.value.value]
    }
  }

/*
  filter = "virtulization-type" {

       name = "virtulization-type"
       value = ["hvm"]
  }

  filter {

    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }


  filter {

    name   = "architecture"
    values = ["x86*"]
  }
*/

}


data "aws_availability_zones" "azs" {
  state = "available"

  filter {
    name = "zone-name"
    values = ["us-east-2*"]
  }
}

locals {
  datafilter = [{name="name",value="amzn2-ami-hvm-2.0*"},
    {name="architecture",value="x86*"},{name="virtualization-type",value="hvm"}]
}


data "aws_ami_ids" "ids" {
  owners = ["amazon"]
  
  /*
  dynamic "filter"{
    for_each = local.datafilter

    content {
      name = filter.value.name
      values = [filter.value.value]
    }
  }

  */


 /*
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  filter {
    name = "architecture"
    values = ["x86*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  */

}


