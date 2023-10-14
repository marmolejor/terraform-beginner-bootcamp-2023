variable "user_uuid" {
  description = "The UUID of the user"
  type        = string
  validation {
   condition  = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
   error_message = "The provided user_uuid is not in valid UUID format."
  }
}

# variable "bucket_name" {
# type = string
# validation {
# condition = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
# error_message = "Invalid bucket name, please check https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html for more details."
# }
# }

variable "public_path" {
  description = "The file path for the public directory"
  type        = string
}

variable "content_version" {
  description = "Version of the content. Must be a positive integer starting at 1."
  type        = number

  validation {
  condition  = var.content_version >= 1 && floor(var.content_version) == var.content_version
  error_message = "The content_version must be a positive integer starting at 1."
}
}


