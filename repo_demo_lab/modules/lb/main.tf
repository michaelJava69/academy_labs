### NLB CONFIGURATION

resource "aws_lb" "nlb" {
  name                             = "tf-nlb"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  ##subnets                          = [aws_subnet.web1.id, aws_subnet.web2.id] # lobabalnces are load balanced them-seleves by AWS across m$
  subnets                          = var.sub
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
  ##vpc_id = aws_vpc.tfvpc.id                       ## not known yet
  vpc_id   = var.vpc-id
}




