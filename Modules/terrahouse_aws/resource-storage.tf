#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "static_website" {
  # Bucket Naming Rules
  #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html 
  bucket = var.bucket_name

  tags = {
     UserUUid = var.user_uuid
     Hello = "jupiter"

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

# #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
# resource "aws_s3_object" "index_html" {
#   bucket = aws_s3_bucket.static_website.bucket
#   key    = "index.html"
#   source = "${path.root}${var.index_html_filepath}"
#   content_type = "text/html"
   
#   #https://developer.hashicorp.com/terraform/language/functions/filemd5
#   etag = filemd5("${path.root}${var.index_html_filepath}")
# }


# resource "aws_s3_object" "error_html" {
#   bucket = aws_s3_bucket.static_website.bucket
#   key    = "error.html"
#   source = "${path.root}${var.error_html_filepath}"
#   content_type = "text/html"

#   #https://developer.hashicorp.com/terraform/language/functions/filemd5
#   etag = filemd5("${path.root}${var.error_html_filepath}")
# }


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_website.bucket
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
            "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
            "Effect" = "Allow",
            "Principal" = {
                "Service" = "cloudfront.amazonaws.com"
            },
            "Action" = "s3:GetObject",
            "Resource" = "arn:aws:s3:::${aws_s3_bucket.static_website.id}/*",
            # "Condition" = {
            # "StringEquals" = {
            #         "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
            #         #"AWS:SourceArn": data.aws_caller_identity.current.arn (This is a cleaner method)
            #     }
            # }
    }
  })
}