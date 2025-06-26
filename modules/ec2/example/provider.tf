provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Environment = "TF-Ansible-Sandbox"
      Owner       = "Terraform"
    }
  }
}
