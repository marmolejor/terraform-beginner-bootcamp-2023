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

provider "aws" {
  # Configuration options
}

