variable "bucket" {
  type        = string
  description = "Name of S3 bucket"
}

variable "serviceregistry_api" {
  type        = string
  description = "The API endpoint for OD 'serviceregistry' service"
}

variable "app" {
  type        = string
  default     = null
  description = "Name of microservice/app to be used as cost center"
}

variable "team" {
  type        = string
  default     = null
  description = "Team name to be used as cost center"
}

variable "org" {
  type        = string
  default     = null
  description = "Org (EPOD) name to be used as cost center"
}

variable "env" {
  type        = string
  default     = "staging"
  description = "Either 'staging' or 'production'."
}

variable "custom_tags" {
  type        = map
  default     = {}
  description = "AWS tags in addition to auto-generated tags"
}

variable "server_side_encryption" {
  type        = string
  default     = null
  description = "Optional: will provision server_side_encryption_configuration block if present"
}

variable "acl" {
  type        = string
  description = "AWS canned ACL name"
  default     = ""

  # AWS canned ACLs: private, public-read, etc.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html
}
