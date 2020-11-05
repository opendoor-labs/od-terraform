resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket

  force_destroy = false

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = var.server_side_encryption
        }
      }
    }
  }

  dynamic "grant" {
    for_each = var.acl_grants

    content {
      id          = grant.value.id
      permissions = grant.value.permissions
      type        = grant.value.type
      uri         = grant.value.uri
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }

  dynamic "website" {
    for_each = var.website != null ? [var.website] : []

    content {
      index_document = website.value.index_document
      error_document = website.value.error_document
    }
  }

  dynamic "versioning" {
    for_each = var.versioning != null ? [var.versioning] : []

    content {
      enabled    = versioning.value.enabled
      mfa_delete = versioning.value.mfa_delete
    }
  }

  dynamic "logging" {
    for_each = var.logging != null ? [var.logging] : []

    content {
      target_bucket = logging.value.target_bucket
      target_prefix = logging.value.target_prefix
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days
      id                                     = lifecycle_rule.value.id
      enabled                                = lifecycle_rule.value.enabled
      prefix                                 = lifecycle_rule.value.prefix

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expirations
        content {
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expirations
        content {
          days = noncurrent_version_expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.noncurrent_version_transitions
        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }

    }
  }

  policy = var.policy

  tags = merge(
    {
      app = var.app
      env = var.env

      # both team and org *must* have non-null values
      team = coalesce(module.ownership.team, module.team_org.team)
      org  = coalesce(module.ownership.org, module.team_org.org)

    },
    var.custom_tags
  )
}
