variable "bucket" {
  type        = string
  description = "Name of S3 bucket"
}

variable "region" {
  type        = string
  description = "AWS region to provision bucket at"
  default     = "us-east-1"
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
  type        = map(string)
  default     = {}
  description = "AWS tags in addition to auto-generated tags"
}

variable "server_side_encryption" {
  type        = string
  default     = null
  description = "Optional: will provision server_side_encryption_configuration block if present"
}

variable "acl_grants" {
  type = list(object({
    id          = string
    permissions = list(string)
    type        = string
    uri         = string
  }))

  description = "ACL policy grants for S3 bucket"
  default     = []

  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#using-acl-policy-grants
}

variable "cors_rules" {
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))

  description = "ACL policy grants for S3 bucket"
  default     = []

  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#using-cors
}

variable "website" {
  type = object({
    index_document = string
    error_document = string
  })

  description = "Settings to enable simple website hosting from S3 bucket"
  default     = null
}

variable "versioning" {
  type = object({
    enabled    = bool
    mfa_delete = bool
  })

  description = "Settings to enable versioning on S3 bucket"
  default     = null
}

variable "logging" {
  type = object({
    target_bucket = string
    target_prefix = string
  })

  description = "Settings to enable logging on S3 bucket"
  default     = null
}

variable "policy" {
  type        = string
  description = "(opt) Bucket policy"
  default     = null
}

variable "lifecycle_rules" {
  type = list(object({
    abort_incomplete_multipart_upload_days = number
    id                                     = string
    enabled                                = bool
    prefix                                 = string

    expirations = list(object({
      days                         = number
      expired_object_delete_marker = bool
    }))

    noncurrent_version_expirations = list(object({
      days = number
    }))

    transitions = list(object({
      days          = number
      storage_class = string
    }))

    noncurrent_version_transitions = list(object({
      days          = number
      storage_class = string
    }))
  }))

  description = "Lifecycle rules for S3 bucket"
  default     = []

  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#using-object-lifecycle
}
