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
