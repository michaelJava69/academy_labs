
resource "aws_instance" "instance" {

 
  ami      = data.aws_ami.amazonlinux.id 
  ## instance_type = "t2.micro"
  instance_type = [for e in var.type : lower(e)][0]
  ## availability_zone = {for k,v in  var.ohio_azs : k => format(v, "c") if k == "az2"}
  availability_zone = tostring({for k,v in  var.ohio_azs : k => format(v, "c") if k == "az2"}["az2"])
  ## availability_zone = "us-east-2c"
   
  #######################################
  ## for default vpc you can use name
  ## non default vpc you use the id  
  ######################################
  
  security_groups = [aws_security_group.fw.name]
}

/*

results

data.external.echo: Refreshing state...
aws_iam_user.user["arun"]: Refreshing state... [id=arun]
data.aws_availability_zones.azs: Refreshing state...
data.aws_ami.amazonlinux: Refreshing state...
aws_iam_user.user["dave"]: Refreshing state... [id=dave]
aws_security_group.fw: Refreshing state... [id=sg-028203e2d893cef0a]
aws_instance.instance2[0]: Refreshing state... [id=i-0eab859f03fce73ec]
aws_instance.instance2[1]: Refreshing state... [id=i-0c41c3b6396dc99dc]
aws_instance.instance: Creating...
aws_instance.instance: Still creating... [10s elapsed]
aws_instance.instance: Still creating... [20s elapsed]
aws_instance.instance: Creation complete after 29s [id=i-014ef47f162d4590b]


*/




resource "aws_instance" "instance2" {

  count = 2
  ami      = data.aws_ami.amazonlinux.id
  ## instance_type = "t2.micro"
  instance_type = [for e in var.type : lower(e)][0]
  ## availability_zone = {for k,v in  var.ohio_azs : k => format(v, "c") if k == "az2"}
  availability_zone = {for k,v in  var.ohio_azs : k => format(v, "b") if k == "az1"}["az1"]
}



####
#  IAM use case
#############

resource "aws_iam_user"  "user"  {


   for_each = toset([for e in var.user: base64decode(e)])
      name = each.value
      ## name = each.key

}


locals {
  ingress_config = toset([80,22,443,52])
  ingress_config2 = [{port=80,description="http",protocol="tcp"},
    {port=22,description="ssh",protocol="tcp"},
    {port=443,description="ssl",protocol="tcp"},
    {port=53,description="dns",protocol="tcp"}]

}




resource "aws_security_group" "fw" {

  #  depends_on = [aws_iam_user.user]    

    dynamic "ingress" {

    ##  iterator = ingress_config_itr

    for_each = local.ingress_config2
    ## for_each = local.ingress_config

       /*
       content {
         description = "test"
         protocol = "tcp"
         to_port = ingress_config_itr.value
         from_port = ingress_config_itr.value
         cidr_blocks = [
            "0.0.0.0/0"]
       }
       */

    content {
      description = ingress.value.description
      protocol = ingress.value.protocol   
      to_port = ingress.value.port
      from_port = ingress.value.port
      cidr_blocks = [
        "0.0.0.0/0"]
    }
   
  }

  /*
  ingress {
         description = "test"
         protocol = "tcp"
         to_port = 80
         from_port = 80
         cidr_blocks = [
            "0.0.0.0/0"]
   }
  */


  egress {
    description = "allow_all"
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}




/*

> format("Hello, %s!", "Ander")
Hello, Ander!
> format("There are %d lights", 4)
There are 4 lights

*/
