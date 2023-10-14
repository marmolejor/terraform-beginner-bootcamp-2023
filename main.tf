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
  cloud {
    organization = "juanmarmolejo"

    workspaces {
      name = "terra-house-1"
    }
  }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid=var.teacherseat_user_uuid
  token=var.terratowns_access_token
}

module "home_mario_hosting" {
  source      = "./Modules/terrahome_aws"
  user_uuid   = var.teacherseat_user_uuid
  public_path = var.mario.public_path
  content_version = var.mario.content_version
}

resource "terratowns_home" "mario-home" {
  name = "Why Mario Bros is the best video game to get started in video games"
  description = <<DESCRIPTION
  The "Super Mario Bros." video games series, starting with its initial release in 1985 for the Nintendo Entertainment System (NES), 
  is frequently heralded as a great entry point for those new to video games. 
DESCRIPTION
  domain_name = module.home_mario_hosting.domain_name
  town = "missingo"
  content_version = var.mario.content_version
}

module "home_mex_hosting" {
  source      = "./Modules/terrahome_aws"
  user_uuid   = var.teacherseat_user_uuid
  public_path = var.mex.public_path
  content_version = var.mex.content_version
}

resource "terratowns_home" "mex-cuisine" {
  name = "One of the best things from Mexico is the food, YOU MUST TRY IT!"
  description = <<DESCRIPTION
  Mexican cuisine was recognized by UNESCO as Intangible Cultural Heritage in 2010. This place of honor is 
  shared only with the Mediterranean diet and the social uses of the French and Japanese cuisines. 
  What does this recognition mean? That our cuisine has been passed down as a legacy through the generations 
  and is alive today as an expression of our identity.
DESCRIPTION
  domain_name = module.home_mex_hosting.domain_name
  town = "missingo"
  content_version = var.mex.content_version
}
