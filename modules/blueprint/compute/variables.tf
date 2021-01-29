variable "az" {
  type = string
  ## if you leave out then this forces a required argument
  default = "us-east-2a"

}


variable "type" {
   ## restricts to a string
   type = string
   default = "t2.micro"
}


variable "image"  {
   ##  default =  "ami-123456"
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

