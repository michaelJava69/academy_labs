
resource "aws_instance" "instance" {

 
  ami      = data.aws_ami.amazonlinux.id 
  ## instance_type = "t2.micro"
  instance_type = [for e in var.type : lower(e)][0]
  ## availability_zone = {for k,v in  var.ohio_azs : k => format(v, "c") if k == "az2"}
  availability_zone = {for k,v in  var.ohio_azs : k => format(v, "c") if k == "az2"}["az2"]  
}

resource "aws_instance" "instance2" {

  count = 2
  ami      = data.aws_ami.amazonlinux.id
  ## instance_type = "t2.micro"
  instance_type =  var.tier == "free-tier" ? "t2.micro" : "t2.large"
  ## availability_zone = {for k,v in  var.ohio_azs : k => format(v, "c") if k == "az2"}
  availability_zone = {for k,v in  var.ohio_azs : k => format(v, "c") if k == "az1"}["az1"]
}



####
#  IAM use case
#############

resource "aws_iam_user"  "user"  {

   for_each = toset([for e in var.user: base64decode(e)])
      name = each.value
      ## name = each.key

}




/*

> format("Hello, %s!", "Ander")
Hello, Ander!
> format("There are %d lights", 4)
There are 4 lights

*/
