module "ownership" {
  source = "github.com/opendoor-labs/od-terraform/modules/ownership"

  serviceregistry_api = var.serviceregistry_api
  service_key         = var.app
}

module "team_org" {
  source = "github.com/opendoor-labs/od-terraform/modules/team_org"

  serviceregistry_api = var.serviceregistry_api
  team                = var.team
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket
  acl    = var.acl

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

  tags = merge(
    {
      app  = var.app
      env  = var.env

      team = coalesce(module.ownership.team, module.team_org.team)
      org  = coalesce(module.ownership.org,  module.team_org.org)

    },
    var.custom_tags # we can overwrite tags if necessary
  )
}
