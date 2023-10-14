terraform {
#   cloud {
#    organization = "juanmarmolejo"
#     workspaces {
#       name = "terra-house-1"
#     }
#   }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}


#https://developer.hashicorp.com/terraform/language/data-sources
data "aws_caller_identity" "current"{}

