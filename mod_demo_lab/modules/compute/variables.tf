locals {
  ingress_config = toset([80,22,443,52])
  ingress_config2 = [{port=80,description="http",protocol="tcp"},
    {port=22,description="ssh",protocol="tcp"},
    {port=443,description="ssl",protocol="tcp"},
    {port=53,description="dns",protocol="tcp"}]

}



## -----------------------------------
##   Required
## ---------------------------------

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



variable "vpc-zone-identifier" {}

variable "target-group-arns" {}



# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "user-data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}


variable "cluster-name" {
   description = "cluster name"
   type        = string
   default     = "" 

}

variable "enable_autoscaling" {
  description = "enable change in autoscale"
  type = bool
  default =  false
}

variable "min-size"{
  description = "asg min size"
  default     = 2
  
}

variable "max-size"{
  description = "asg max size"
  default     = 2

}

