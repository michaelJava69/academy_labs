




## local-exec provisioner
/*

resource "aws_instance" "example2" {
  provider = aws

  ## lets refer to a data source for the ami image instead of looking 
  ## up on console and hardcoding in variables/ here
  
  
  # ami = "ami-0c55b159cbfafe1f0"
    ami = data.aws_ami.amazonlinux.id


  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = " echo ${self.id}  >> michael.txt"
  }

}

*/

## User Data

resource "aws_instance" "instance" {

  ###
  # lets refer to a data source for the ami image instead of looking
  # up on console and hardcoding in variables/ here
  ######
 
  # ami           = "ami-0a0ad6b70e61be944"
  ami = data.aws_ami.amazonlinux.id

  instance_type = "t2.micro"

  # for aws_launch_configuration
  # security_groups = [aws_security_group.instance.id]

  vpc_security_group_ids = [aws_security_group.instance.id]

  key_name  = aws_key_pair.ssh.key_name
  user_data = var.user_data
}


## Secvurity group

resource "aws_security_group" "instance" {
  name = var.instance_security_group_name

  ## becuase we are using a non default VPC
  ## vpc_id = aws_vpc.tfvpc.id

  ##

  /*
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
*/

  ingress {
    from_port   = var.server_ssh
    to_port     = var.server_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}



## now need aws key pair to enable ssh
resource "aws_key_pair" "ssh" {
  key_name   = "awspubkey"
  public_key = file("~/certification/keypair/chapter5.pub")
}





resource "null_resource" "example2" {

  triggers = {
    uuid = uuid()

  }

  provisioner "local-exec" {
    command = " echo self id is ${self.id}  and uuid is $(uname -smp) >> michael.txt"

  }

}

