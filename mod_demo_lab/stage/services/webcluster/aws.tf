terraform {
  backend "s3" {

    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

     bucket         = "terraform-s3-bucket-state"
     key            = "stage/webcluster/mod/stage/terraform.tfstate"
     region         = "us-east-2"
     dynamodb_table = "terraform-s3-bucket-state-locks"
     encrypt        = true

  }
}

## modules

module "stage-compute"  {
   source = "../../../modules/compute"

   ## variable names in the module variable.tf
   cluster-name = "stage-cluster"
   image = data.aws_ami.ami.id
   type = var.stage-type
   vpc-id =  "${module.stage-network.vpc-id}"
   vpc-zone-identifier  = ["${module.stage-network.aws_subnet-web1-id}", "${module.stage-network.aws_subnet-web2-id}"]
   target-group-arns    = ["${module.stage-lb.target_group_arn}"]
   user-data            = var.user_data

   min-size             = 1
   max-size             = 1
   enable_autoscaling   = true
  
}



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


/*
output "aws_subnet-web1-id"  {
   value = aws_subnet.web1.id
}
output "aws_subnet-web2-id"  {
   value = aws_subnet.web2.id
}

output "target_group_arn" {
   value = aws_lb_target_group.pool.arn
}

*/


module "stage-lb" {

   ## contains loadbalancer confgis
   source = "../../../modules/lb"
   #sub = var.stage-sub
   sub = ["${module.stage-network.aws_subnet-web1-id}", "${module.stage-network.aws_subnet-web2-id}"]
   vpc-id =  "${module.stage-network.vpc-id}"
    
}


## modules
