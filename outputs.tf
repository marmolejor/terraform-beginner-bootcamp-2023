#https://registry.terraform.io/providers/hashicorp/random/latest/docs
output "random_bucket_name" {
 value = random_string.bucket_name.result
}