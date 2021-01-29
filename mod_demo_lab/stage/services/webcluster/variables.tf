variable "prod-az" {
   default = ["us-east-2a", "us-east-2b", "us-east-2c" ]
}


variable "prod-type" {
   default = "t2.micro"
}

variable "prod-user" {
  default = "john"
}


variable "vpc-prod"  {
  default = "172.30.0.0/16"

}

variable "prod-sub"  {
  default = ["172.30.10.0/24" ,"172.30.20.0/24"]


}



locals {
  datafilter = [{name="name",value="amzn2-ami-hvm-2.0*"},
    {name="architecture",value="x86*"},{name="virtualization-type",value="hvm"}]
}


data "aws_ami" "ami" {

  owners      = ["amazon"]
  most_recent = true

  dynamic "filter"{
    for_each = local.datafilter

    content {
      name = filter.value.name
      values = [filter.value.value]
    }
  }
}






###############


variable "instance_security_group_name" {
  description = "The name of security group for EC2 load balanced instances"
  type        = string
  default     = "terraform-awslaunch-instance"
}


variable "az" {
  default = ["us-east-2b", "us-east-2c", "us-east-2d"]
}

variable "server_port" {
  default = "80"
  type    = number
}

variable "server_ssh" {
  default = "22"
  type    = number

}

variable "user_data" {
  description = "user data for apache script"
  default     = <<-EOF
#!/bin/bash
sudo yum -y update
sudo yum install -y httpd
sudo service httpd start
echo '<!doctype html><html><head><title>CONGRATULATIONS!!..You are on your way to become a Terraform expert!</title><style>body {background-color: #1c87c9;}</style></head><body></body></html>' | sudo tee /var/www/html/index.html
echo "<BR><BR>Terraform autoscaled app multi-cloud lab<BR><BR>" >> /var/www/html/index.html
EOF
}




## list
variable "user" {
   description = "base 64 encoded message"
   default = ["ZGF2ZQ==" , "YXJ1bg=="] 

}


