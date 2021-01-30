/*

### NLB CONFIGURATION

resource "aws_lb" "nlb" {
  name                             = "tf-nlb"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  subnets                          = [aws_subnet.web1.id, aws_subnet.web2.id] # lobabalnces are load balanced them-seleves by AWS across m$

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
  vpc_id = aws_vpc.tfvpc.id                       ## not known yet


}


*/



##   NEWTWORK SETUP 

resource "aws_vpc" "tfvpc" {
  # cidr_block = "172.20.0.0/16"
  cidr_block = var.vpc
  tags = {
    name = "tf-vpc"
  }
}


resource "aws_subnet" "web1" {

  cidr_block        = element(var.sub, 0) 
  # cidr_block        = "172.20.10.0/24"
  vpc_id            = aws_vpc.tfvpc.id
  availability_zone = element(var.az,0) 
  # availability_zone = element(data.aws_availability_zones.azs.names, 0)

  tags = {
    name = "web1"
  }

}

resource "aws_subnet" "web2" {
  
  cidr_block        = element(var.sub, 1)
  # cidr_block        = "172.20.20.0/24"
  vpc_id            = aws_vpc.tfvpc.id
  availability_zone = element(var.az,1)
  # availability_zone = element(data.aws_availability_zones.azs.names, 1)


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

