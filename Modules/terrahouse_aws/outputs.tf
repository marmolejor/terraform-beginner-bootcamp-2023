output "bucket_name" {
  value = aws_s3_bucket.static_website.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static.website_endpoint
}

#This should not be here I put it to see what happens
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "cloudfront_url"{
 value = aws_cloudfront_distribution.s3_distribution.domain_name
}