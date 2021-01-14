data "aws_availability_zones" "azs" {
  state = "available"

  filter {
    name   = "zone-name"
    values = ["us-east-2*"]
  }
}
###
## Filtering imgaes out on EC2 / Images page
## https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2#Images:visibility=public-images;ownerAlias=amazon;architecture=x86_64;sort=name

###
#### 

data "external" "echo" {

  program = ["bash", "-c", "cat /dev/stdin"]

  query = {
    foo = "bar"
  }

}



##########################
#
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


  filter {

    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }


  filter {

    name   = "architecture"
    values = ["x86*"]
  }

}


### vpc

data "aws_vpc" "default" {

    #cidr_block = "172.20.0.0/16"
    default =  true

}

#########
#
#  want to use an existing vpc for a particular cidr block
#  https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeVpcs.html
#############
data "aws_vpc" "exist" {

    default = false

    filter {

          name = "cidr"
          #values  = ["172.20.*"]
          values  = ["172.31.*"]
    }

    filter {

          name = "state"
          #values  = ["172.20.*"]
          values  = ["pending", "available"]
    }

}


### bringing back instances in my provider region

data "aws_ec2_instance_type_offerings" "t2"  {

    location_type = "region"

    filter {
         name = "instance-type"
         values = ["t2.*"]
    }

}

