variable "filename" {
    description = "The file name to use"
    default = "atlast.txt"

    ## no value given so will be prompted unless terraform apply -var filename=michael.txt    
    ## or because we have got myvars.tfvars it is not named terraform.tfvars but can call using

    ## Order of lookup
     
    ## 1. terraform apply -var-file=myvars.tfvars
    ## 2. or it looks for <filename>.auto.tfvars    : if can not find

    ## 3. or rename myvars.tfvars as terraform.tfvars
    ## 4. default  in variables.tf file
  
    ## 5 .prompted
}
