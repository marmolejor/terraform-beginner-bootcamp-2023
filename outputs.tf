output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value       = module.terrahouse_aws.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 static website hosting endpoint"
  value       = module.terrahouse_aws.website_endpoint
}

#This should not be here I put it to see what happens
output "account_id" {
  value = module.terrahouse_aws.account_id
}