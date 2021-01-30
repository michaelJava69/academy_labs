terraform {
  backend "s3" {

    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

     bucket         = "terraform-s3-bucket-state"
     key            = "stage/webcluster/mod/terraform.tfstate"
     region         = "us-east-2"
     dynamodb_table = "terraform-s3-bucket-state-locks"
     encrypt        = true

  }
}

## modules

module "prod-compute"  {
   source = "../../../modules/compute"

   ## variable names in the module variable.tf
   user-data = var.user-data
   cluster-name = "prod-stage"
   image = data.aws_ami.ami.id
   type = var.prod-type
   vpc-id =  "${module.prod-network.vpc-id}"
   vpc-zone-identifier  = ["${module.prod-network.aws_subnet-web1-id}", "${module.prod-network.aws_subnet-web2-id}"]
   target-group-arns    = ["${module.prod-lb.target_group_arn}"] 

   min-size             = 1
   max-size             = 1
   enable_autoscaling   = true
}

/*
output "aws_subnet-web1-id"  {
   value = aws_subnet.web1.id
}
output "aws_subnet-web2-id"  {
   value = aws_subnet.web2.id
}
*/


module "prod-iam"  {
   source = "../../../modules/iam"


}


module "prod-lb" {

   ## contains loadbalancer confgis
   source = "../../../modules/lb"
   #sub = var.stage-sub
   sub = ["${module.prod-network.aws_subnet-web1-id}", "${module.prod-network.aws_subnet-web2-id}"]
   vpc-id =  "${module.prod-network.vpc-id}"

}



module "prod-network" {

   ## contains vpc and sub network confgis
   source = "../../../modules/network"
   sub = var.prod-sub
   vpc = var.vpc-prod
   az = var.prod-az 
}

## modules
