provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Environment = "Catalog-Modules-Sandbox"
      Owner       = "Terraform"
    }
  }
}
