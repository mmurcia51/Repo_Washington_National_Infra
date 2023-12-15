# provider "aws" {
#   region     = "us-east-1"
#   alias      = "virginia"
#   access_key = "AKIA6CY4IDLETEVNMFW4"
#   secret_key = "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"
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