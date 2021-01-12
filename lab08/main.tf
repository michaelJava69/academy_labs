data "aws_availability_zones" "zones" {
  exclude_names = ["us-west-2d"]
}

