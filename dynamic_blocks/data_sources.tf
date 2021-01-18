data "aws_availability_zones" "azs" {
  state = "available"

  filter {
    name   = "zone-name"
    values = ["us-east-2*"]
  }
}



data "external" "echo" {

   program = [ "bash", "-c" , "cat /dev/stdin"]

   query = {
     foo = "bar"
   }

}

