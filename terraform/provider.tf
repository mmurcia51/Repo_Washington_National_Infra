# provider "aws" {
#   region     = "us-east-1"
#   alias      = "virginia"
#   access_key = 
#   secret_key = 
# }

terraform {
  required_version = ">= 1.4.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 5.0.0"
    }
  }
}
