locals {
  ingress_config = toset([80,22,443,52])
  ingress_config2 = [{port=80,description="http",protocol="tcp"},
    {port=22,description="ssh",protocol="tcp"},
    {port=443,description="ssl",protocol="tcp"},
    {port=53,description="dns",protocol="tcp"}]

}

variable "az" {
  type = string
  ## if you leave out then this forces a required argument
  default = "us-east-2a"

}


variable "vpc-id" {}

variable "type" {
   ## restricts to a string
   type = string
   default = "t2.micro"
}


variable "image"  {
   ##  default =  "ami-123456"
}


variable "user_data" {
  description = "user data for apache script"
  default     = <<-EOF
#!/bin/bash
sudo yum -y update
sudo yum install -y httpd
sudo service httpd start
echo '<!doctype html><html><head><title>CONGRATULATIONS!!..You are on your way to become a Terraform expert!</title><style>body {background-color: #1c87c9;}</style></head><body></body></html>' | sudo tee /var/www/html/index.html
echo "<BR><BR>Terraform autoscaled app multi-cloud lab<BR><BR>" >> /var/www/html/index.html
EOF
}

variable "vpc-zone-identifier" {}

variable "target-group-arns" {}

