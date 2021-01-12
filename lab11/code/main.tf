terraform {
  required_version = ">= 0.13, < 0.14"

  backend "s3" {
    bucket         = "terraform-training-state-69"  
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"


    dynamodb_table = "terraform-training-locks"

    # Setting this to true ensures that the Terrafrom state will be encrypted on disk when stored in S3, even if the bucket itself does not have default encryption enabled.
    # In our case, the S3 bucket itself has already been configured with default encryption enabled, so setting this here is redundant.
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

}

