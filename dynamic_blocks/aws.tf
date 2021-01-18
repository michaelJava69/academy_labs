
resource "aws_launch_configuration" "awslaunch" {

  name          = "aws_launch"
  image_id      = "ami-0a0ad6b70e61be944"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.instance.id]

  ## becuase we are using a non default VPC
  associate_public_ip_address = true

  ##

  key_name  = aws_key_pair.ssh.key_name
  user_data = var.user_data
}


resource "aws_security_group" "instance" {
  name = "aws-fw"
  vpc_id = aws_vpc.tfvpc.id

  dynamic "ingress" {

    ##  iterator = ingress_config_itr

    for_each = local.ingress_config2
    ## for_each = local.ingress_config

    /*
    content {
      description = "test"
      protocol = "tcp"
      to_port = ingress_config_itr.value
      from_port = ingress_config_itr.value
      cidr_blocks = [
        "0.0.0.0/0"]
    }

    */

    content {
      description = ingress.value.description
      protocol = ingress.value.protocol   
      to_port = ingress.value.port
      from_port = ingress.value.port
      cidr_blocks = [
        "0.0.0.0/0"]
    }
   
  }

  egress {
    description = "allow_all"
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

/*

resource "aws_security_group" "instance" {
  name = var.instance_security_group_name

  ## becuase we are using a non default VPC
  vpc_id = aws_vpc.tfvpc.id

  ##

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = var.server_ssh
    to_port     = var.server_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

*/

## now need aws key pair to enable ssh
resource "aws_key_pair" "ssh" {
  key_name   = "awspubkey"
  public_key = file("~/certification/keypair/chapter5.pub")
}

## create autoscaling group

resource "aws_autoscaling_group" "tfasg" {
  name     = "tfasg"
  max_size = 4
  min_size = 3

  ## need to know type of instance it going to scale

  launch_configuration = aws_launch_configuration.awslaunch.name

  ## want to pass in the ids of each subnet configured for each availability zone
  vpc_zone_identifier = [aws_subnet.web1.id, aws_subnet.web2.id] ## we dont have this yet

  ## need to giveaddress where the servers are . They are in a pool created by NLB so need to point at this POOL
  target_group_arns = [aws_lb_target_group.pool.arn] # dont know yet

  ## give instances names via tag

  tag {
    key                 = "Name"
    propagate_at_launch = true ## adds lables to all instances created by ASG
    value               = "tf-ec2VM"
  }

}

### NLB configuration

resource "aws_lb" "nlb" {
  name                             = "tf-nlb"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  subnets                          = [aws_subnet.web1.id, aws_subnet.web2.id] # lobabalnces are load balanced them-seleves by AWS across multiple subnets zones


}


resource "aws_lb_listener" "frontend" {

  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pool.arn
  }
}

resource "aws_lb_target_group" "pool" {
  name     = "web"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.tfvpc.id ## not known yet
}

##   network set up

resource "aws_vpc" "tfvpc" {
  cidr_block = "172.20.0.0/16"

  tags = {
    name = "tf-vpc"
  }
}


resource "aws_subnet" "web1" {
  cidr_block        = "172.20.10.0/24"
  vpc_id            = aws_vpc.tfvpc.id
  availability_zone = element(data.aws_availability_zones.azs.names, 0)

  tags = {
    name = "web1"
  }

}

resource "aws_subnet" "web2" {
  cidr_block        = "172.20.20.0/24"
  vpc_id            = aws_vpc.tfvpc.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)

  tags = {
    name = "web2"
  }
}
## to route trafic frominternete through vpc ( not needed when you use DEFAULT VPC

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tfvpc.id

  tags = {
    name = "igw"
  }
}


## BECUASE USING NON DEAFULT VPC have to define own route table

resource "aws_route" "tfroute" {
  route_table_id         = aws_vpc.tfvpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


#########
#
# --- extra not using. just for illustration
#
####

resource "aws_codebuild_project" "lab-cicd" {

   name = "lab-cicd-project"
   service_role = "code-build-iam-servoce-role"
   
   artifacts {
       type = "NO_ARTIFACTS"
   } 


   environment {
      
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "aws/codebuild/standard:1.0"
      type = "LINUX_CONTAINER"

      dynamic environment_variable {

         iterator = environments

         for_each = local.environment_variable 

            content {
               name = environments.value.name
               value =  environments.value.value
            }
         
      }

/*

      environment_variable {
         name = "mykeys"
         value = "keys.json"
      }

      environment_variable {
         name = "mycreds"
         value = "creds.json"
      }

      environment_variable {
         name = "data"
         value = "mydata.json"
      }
*/

   }

   source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
   

}

locals {
  environment_variable = [{name="mykeys",value="keys.json"},
    {name="mycreds",value="creds.json"},
    {name="data",value="mydata.json"}]

}
