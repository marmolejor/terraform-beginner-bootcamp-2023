variable "user_uuid" {
  description = "The UUID of the user"
  type        = string
  validation {
   condition  = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
   error_message = "The provided user_uuid is not in valid UUID format."
  }
}

variable "bucket_name" {
type = string
validation {
condition = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.bucket_name))
error_message = "Invalid bucket name, please check https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html for more details."
}
}

# variable "index_html_filepath" {
#   description = "Filepath for index.html"
#   type        = string
# validation {
#   condition  = can(fileexists(var.index_html_filepath))
#   error_message = "The provided index_html_filepath does not point to a valid file."
# }
# }

# variable "error_html_filepath" {
#   description = "Filepath for index.html"
#   type        = string
# validation {
#   condition  = can(fileexists(var.error_html_filepath))
#   error_message = "The provided error_html_filepath does not point to a valid file."
# }
# }