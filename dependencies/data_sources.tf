data "aws_availability_zones" "azs" {
  state = "available"

  filter {
    name   = "zone-name"
    values = ["us-east-2*"]
  }
}



data "external" "echo" {

   program = [ "bash", "-c" , "cat /dev/stdin"]

   query = {
     foo = "bar"
   }

}


locals {
  datafilter = [{name="name",value="amzn2-ami-hvm-2.0*"},
    {name="architecture",value="x86*"},{name="virtualization-type",value="hvm"}]
}


data "aws_ami" "amazonlinux" {

  owners      = ["amazon"]
  most_recent = true

  dynamic "filter"{
    for_each = local.datafilter

    content {
      name = filter.value.name
      values = [filter.value.value]
    }
  }

/*
  filter = "virtulization-type" {
       name = "virtulization-type"
       value = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  filter {
    name   = "architecture"
    values = ["x86*"]
  }
*/

}
