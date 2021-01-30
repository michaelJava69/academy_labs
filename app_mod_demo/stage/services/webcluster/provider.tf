provider "aws" {
  region  = "us-east-2"
  version = "~> 2.0"
}



##
provider "aws" {
  alias   = "califonia"
  region  = "us-east-2"
  version = "~> 2.0"
}

provider "azurerm" {
  version = "~> 2.40"
  features {}
}
