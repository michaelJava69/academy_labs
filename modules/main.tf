
module "prod-compute"  {
   source = "./blueprint/compute"

   ## variable names in the module variable.tf
   image = data.aws_ami.ami.id
   type = var.prod-type
   az = var.prod-az[1]
}




module "prod-iam"  {
   source = "./blueprint/iam"
   user = var.prod-user

}

module "prod-network" {

   ## contains vpc and sub network confgis
   source = "./blueprint/network"
   vpc = var.vpc-prod
   sub = var.prod-sub
   vpc-id = module.prod-network.vpc-id
}



/*

ERROR 

module "sub"  {
   source = "./blueprint/network"
   sub = var.sub
   vpc = var.vpc-prod
}

*/

