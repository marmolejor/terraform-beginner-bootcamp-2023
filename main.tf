terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "ExamPro"

  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}
  #cloud {
  #  organization = "ExamPro"
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}

}

provider "terratowns" {
  endpoint = "https://terratowns.cloud/api"
  user_uuid=var.teacherseat_user_uuid
  token=var.terratowns_access_token
}

module "terrahouse_aws" {
  source      = "./Modules/terrahouse_aws"
  user_uuid   = var.teacherseat_user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}


resource "terratowns_home" "mariohome" {
  name = "Why Mario Bros is the best video game to get started in video games"
  description = <<DESCRIPTION
  The "Super Mario Bros." video games series, starting with its initial release in 1985 for the Nintendo Entertainment System (NES), 
  is frequently heralded as a great entry point for those new to video games. 
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}
