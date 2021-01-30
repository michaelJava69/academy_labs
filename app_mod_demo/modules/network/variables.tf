variable "vpc" {}


variable "sub" {}



variable "az" {
  type = list
  ## if you leave out then this forces a required argument
  ## default = "us-east-2a"

}
