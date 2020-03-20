variable "serviceregistry_api" {
  type        = string
  description = "Service registry API endpoint to test against"

  # no default value would force a developer to enter a value during testing
}

variable "region" {
  type        = string
  description = "AWS region to test against"
  default     = "us-east-2"
}

variable "logging_grant" {
  type = object({
    id          = string
    permissions = list(string)
    type        = string
    uri         = string
  })

  description = "Allow AWS to store access logs to given S3 bucket"

  default = {
    id          = null
    permissions = ["READ_ACP", "WRITE"]
    type        = "Group"
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }
}

variable "read_only_grant" {
  type = object({
    id          = string
    permissions = list(string)
    type        = string
    uri         = string
  })

  description = "Public read-only access to given S3 bucket"

  default = {
    id          = null
    permissions = ["READ"]
    type        = "Group"
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
  }
}

variable "cors_get_any" {
  type = object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  })

  description = "CORS allow GET for any header from any source"

  default = {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

variable "versioning_enabled" {
  type = object({
    enabled    = bool
    mfa_delete = bool
  })

  description = "Typical settings to enable versioning on S3 bucket"

  default = {
    enabled    = true
    mfa_delete = false
  }
}
