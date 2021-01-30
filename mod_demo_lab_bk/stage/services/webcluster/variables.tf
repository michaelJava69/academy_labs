variable "stage-az" {
   default = ["us-east-1a", "us-east-1b", "us-east-1c" ]
}


variable "stage-type" {
   default = "t2.micro"
}

variable "stage-user" {
  default = "john"
}


variable "vpc-stage"  {
  default = "172.40.0.0/16"

}

variable "stage-sub"  {
  default = ["172.40.10.0/24" ,"172.40.20.0/24"]


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
