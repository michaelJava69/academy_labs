resource "aws_vpc" "vpc-test" {
   cidr_block = var.vpc

}

resource "aws_subnet" "sub" {

   cidr_block = var.sub
   vpc_id = var.vpc-id
}

