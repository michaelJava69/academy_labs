data "aws_availability_zones" "zones" {

  ## exclude_names =  []
  exclude_names =  ["eu-west-2a"]
}

