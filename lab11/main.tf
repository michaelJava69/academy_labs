/*

terraform {
  required_version = ">= 0.13, < 0.14"
  required_providers {
    aws = {
       source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

*/

terraform {
  required_providers {
    aws = "~> 3.0"
  }
}

locals {
  tags = {
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = "2020-11-11"
  }
}

provider "aws" {
  region = "eu-west-2"
}

