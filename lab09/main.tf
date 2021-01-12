provider "aws" {
  region = "eu-west-1"

}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"

}

data "aws_ami" "eu_west_1" {
  most_recent = true
  owners      = ["099720109477"] # Cannoncial

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"]
  }
}

data "aws_ami" "eu_west_2" {
  provider = aws.london

  most_recent = true
  owners      = ["099720109477"] # Cannoncial

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-*"]
  }
}

resource "aws_instance" "server1" {
  ami           = data.aws_ami.eu_west_1.id
  instance_type = "t2.micro"

  tags = {
    Name = "Server 1"
  }
}

resource "aws_instance" "server2" {
  provider = aws.london

  ami           = data.aws_ami.eu_west_2.id
  instance_type = "t2.micro"

  tags = {
    Name = "Server 2"
  }
}

