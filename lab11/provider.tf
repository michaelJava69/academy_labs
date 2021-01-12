/*
## version 0.12

terraform {
  required_providers {
    aws = "~> 3.0"
  }
}

*/



## version 0.13

terraform {
  required_version = ">= 0.13, < 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = "eu-west-2"
}

