terraform {
  backend "s3" {

    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

     bucket         = "terraform-s3-bucket-state"
     key            = "stage/webcluster/app/stage/terraform.tfstate"
     region         = "us-east-2"
     dynamodb_table = "terraform-s3-bucket-state-locks"
     encrypt        = true

  }
}

## modules

module "stage-compute"  {
   source = "../../../modules/compute"

   ## variable names in the module variable.tf
   image = data.aws_ami.ami.id
   type = var.stage-type
   vpc-id =  "${module.stage-network.vpc-id}"
   vpc-zone-identifier  = ["${module.stage-network.aws_subnet-web1-id}", "${module.stage-network.aws_subnet-web2-id}"]
   target-group-arns    = ["${module.stage-network.target_group_arn}"] 
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



module "stage-network" {

   ## contains vpc and sub network confgis
   source = "../../../modules/network"
   #sub = var.stage-sub
   sub = ["${cidrsubnet(var.vpc-stage,8,10)}","${cidrsubnet(var.vpc-stage,8,20)}"]
   vpc = var.vpc-stage
   az = var.stage-az 
}

## modules
