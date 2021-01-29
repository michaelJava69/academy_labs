/*
terraform {
   required_providers {

      aws = {
          source = "hashicorp/aws"
          version = ">3.0.0"
      }
   }
}
*/


provider "aws" {
  region = "eu-west-1"
  version = ">3.0.0"

}


provider "aws" {

   alias = "london"
   region = "eu-west-2"

}

