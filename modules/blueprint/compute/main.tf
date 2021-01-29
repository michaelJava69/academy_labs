resource "aws_instance"  "ec2-mod"  {

   ami = var.image
   instance_type = var.type
   ## force value by usig literally
   ## availability_zone = "us-east-2a"
   availability_zone = var.az
}


