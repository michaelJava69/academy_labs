

/*
terraform init -backend-config=backend.hcl
*/


terraform {
backend "s3" {
    # bucket         = "terraform-training-state-69"
    key            = "example-11-02/terraform.tfstate"
    # region         = "eu-west-2"


    # dynamodb_table = "terraform-training-locks"

    # encrypt        = true
  }
}



## de intializing a backend

/*
comment out backend above

result

michaelugbechie@C02Z50H8LVCJ lab11-1 % terraform init

Initializing the backend...
Terraform has detected you're unconfiguring your previously set "s3" backend
Successfully unset the backend "s3". Terraform will now operate locally.

*/


/*

Results

michaelugbechie@C02Z50H8LVCJ lab11-1 % aws s3 ls --recursive s3://terraform-training-state-69
2021-01-13 17:59:38        156 example-11-02/terraform.tfstate
2021-01-13 12:14:05        156 global/s3/terraform.tfstate

*/

## resources

locals {
  tags = {
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = var.expiration_date
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = local.tags
}


