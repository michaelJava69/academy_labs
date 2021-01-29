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
  region = "eu-west-2"
  version = ">3.0.0"

}

