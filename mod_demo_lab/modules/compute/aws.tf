resource "aws_launch_configuration" "awslaunch" {

  name          = "${var.cluster-name}-aws-launch"
  image_id      =  var.image       
  # "ami-0a0ad6b70e61be944"
  instance_type =  var.type
  # "t2.micro"

  security_groups = [aws_security_group.instance.id]

  ## becuase we are using a non default VPC
  associate_public_ip_address = true

  ##

  key_name  = aws_key_pair.ssh.key_name
  user_data = var.user-data

  lifecycle {
       create_before_destroy = true
  }

}


## now need aws key pair to enable ssh
resource "aws_key_pair" "ssh" {
  key_name   = "awspubkey"
  public_key = file("~/certification/keypair/chapter5.pub")
}



##  SECURITY GROUPS

resource "aws_security_group" "instance" {
  name = "aws-fw"
  # vpc_id = aws_vpc.tfvpc.id

  vpc_id = var.vpc-id

  dynamic "ingress" {

    ##  iterator = ingress_config_itr

    for_each = local.ingress_config2
    ## for_each = local.ingress_config

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


## AUTO SCALER

resource "aws_autoscaling_group" "tfasg" {
  name     = "tfasg"
  max_size = var.max-size
  min_size = var.min-size

  ## need to know type of instance it going to scale

  launch_configuration = aws_launch_configuration.awslaunch.name

  ## want to pass in the ids of each subnet configured for each availability zone
  
  # vpc_zone_identifier = [aws_subnet.web1.id, aws_subnet.web2.id]                 ## we dont have this yet
  vpc_zone_identifier = var.vpc-zone-identifier

  ## need to giveaddress where the servers are . They are in a pool created by NLB so need to point at this POOL
  
  # target_group_arns = [aws_lb_target_group.pool.arn] # dont know yet
  target_group_arns = var.target-group-arns  
  health_check_type = "ELB"

  ## give instances names via tag

  tag {
    key                 = "Name"
    propagate_at_launch = true ## adds lables to all instances created by ASG
    value               = "tf-ec2VM"
  }
}


resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster-name}-scale-out-during-business-hours"
  min_size               = 3
  max_size               = 10
  desired_capacity       = 3
  start_time             = "2021-01-30T16:04:00Z"
  end_time               = "2021-01-30T16:10:00Z"
  #recurrence             = "0 16 * * *"
  autoscaling_group_name = aws_autoscaling_group.tfasg.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster-name}-scale-in-at-night"
  min_size               = 4
  max_size               = 10
  desired_capacity       = 4
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.tfasg.name
}
