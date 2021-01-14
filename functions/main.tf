resource "aws_launch_configuration" "awslaunch" {
  name = var.aws_launchcfg_name
  image_id = data.aws_ami.amazonlinux.image_id

  ##  select an id from a list  if you remove the filter from the data source aws_ami_ids
  ##image_id = data.aws_ami_ids.ids.ids[1]              --correct  
  ## image_id = element(data.aws_ami_ids.ids.ids,1)     --correct

  ## instance_type = "t2.micro"
  instance_type = element(tolist(data.aws_ec2_instance_type_offerings.t2-type.instance_types),3)

  security_groups = [aws_security_group.awsfw.id]
  associate_public_ip_address = var.aws_publicip
  key_name = aws_key_pair.ssh.key_name
  user_data = var.user_data

  lifecycle {
      create_before_destroy = true
  }

 
}


/*

When he had issues requiring me to add that lifecyle he got around it on launch by marking auto scaling groupm for deletion

terraform taint aws_security_group.instance
terraform apply


> data.aws_ami_ids.ids.ids
[
  "ami-0a0ad6b70e61be944",
  "ami-0360cfdb3023a24c4",
  "ami-09558250a3419e7d0",
  "ami-0c7a7b9b057c33d6d",
  "ami-0b0f4c27376f8aa79",
  "ami-009b28ad8707b9ee8",
  "ami-03657b56516ab7912",

> data.aws_ami_ids.ids.ids[1]
ami-0d5f20cc3aeded479
> element(data.aws_ami_ids.ids.ids,1)
ami-0d5f20cc3aeded479

*/






resource "aws_security_group" "awsfw" {
  name = "aws-fw"
  vpc_id = aws_vpc.tfvpc.id

  dynamic "ingress" {
    for_each = local.ingress_config2

    content {
      description = ingress.value.description
      protocol = "tcp"
      to_port = ingress.value.port
      from_port = ingress.value.port
      cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_key_pair" "ssh" {
  key_name = "awspublickey"
  public_key = file("~/certification/keypair/chapter5.pub") ##please use your public key 
  tags = {
    env = "prod"
  }
}

resource "aws_autoscaling_group" "tfasg" {
  name = "tf-asg"
  max_size = 4
  min_size = 2
  launch_configuration = aws_launch_configuration.awslaunch.name
  vpc_zone_identifier = [aws_subnet.web1.id,aws_subnet.web2.id]
  target_group_arns = [aws_lb_target_group.pool.arn]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "tf-ec2VM"
  }
}

//Network Loadbalancer configuration
resource "aws_lb" "nlb" {
  name = "tf-nlb"
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  subnets = [aws_subnet.web1.id,aws_subnet.web2.id]
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 80
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.pool.arn
  }
}

resource "aws_lb_target_group" "pool" {
  name = "web"
  port = 80
  protocol = "TCP"
  vpc_id = aws_vpc.tfvpc.id
}

//network config
resource "aws_vpc" "tfvpc" {
  ##  cidr_block = "172.20.0.0/16"
  ##  cidr_block = cidrsubnet("172.20.0.0/16",0,0)
      cidr_block = cidrsubnet(var.vpc-block,0,0)
}

resource "aws_subnet" "web1" {
  ## cidr_block = "172.20.10.0/24"
  ## cidr_block = cidrsubnet("172.20.0.0/16",8,10)
  cidr_block = cidrsubnet(var.vpc-block,8,10)

  vpc_id = aws_vpc.tfvpc.id
  availability_zone = element(data.aws_availability_zones.azs.names,0)

  tags = {
    name = "web1"
  }

}

resource "aws_subnet" "web2" {
  ## cidr_block = "172.20.20.0/24"
  ## cidr_block = cidrsubnet("172.20.0.0/16",8,20)
  cidr_block = cidrsubnet(var.vpc-block,8,20)

  vpc_id = aws_vpc.tfvpc.id
  availability_zone = element(data.aws_availability_zones.azs.names,1)

  tags = {
    name = "web1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tfvpc.id

  tags = {
    name = "igw"
  }
}

resource "aws_route" "tfroute" {
  route_table_id = aws_vpc.tfvpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
