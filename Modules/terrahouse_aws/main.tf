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


#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "static_website" {
  # Bucket Naming Rules
  #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html 
  bucket = var.bucket_name

  tags = {
     UserUUid = var.user_uuid

   }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration 
#Enabling static website hosting
resource "aws_s3_bucket_website_configuration" "static" {
  bucket = aws_s3_bucket.static_website.bucket

  index_document{ 
    suffix = "index.html"
  }
  error_document { 
    key = "error.html"
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = var.index_html_filepath
  #https://developer.hashicorp.com/terraform/language/functions/filemd5
  etag = filemd5(var.index_html_filepath)
}


resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "error.html"
  source = var.error_html_filepath
  #https://developer.hashicorp.com/terraform/language/functions/filemd5
  etag = filemd5(var.error_html_filepath)
}