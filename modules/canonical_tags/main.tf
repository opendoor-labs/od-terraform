locals {
  registry_base = trimsuffix(var.serviceregistry_api, "/")
  # urlencode uses '+' for spaces. The registry path expects percent-encoding.
  service_encoded   = replace(urlencode(var.service_key), "+", "%20")
  service_owner_url = "${local.registry_base}/v1/service_owner/${local.service_encoded}"

  decoded = try(jsondecode(data.http.service_owner.response_body), null)
  team    = try(local.decoded.team, null)
  org     = try(local.decoded.org, null)

  has_owner = try(trimspace(local.team), "") != "" && try(trimspace(local.org), "") != ""

  tags = merge(
    {
      service      = var.service_key
      "managed-by" = var.managed_by
      repo         = var.repo
    },
    var.env == null ? {} : { env = var.env },
    local.has_owner ? { team = local.team, org = local.org } : {},
  )
}

data "http" "service_owner" {
  url = local.service_owner_url

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Service registry returned HTTP ${self.status_code} for ${var.service_key} (${local.service_owner_url})."
    }
  }
}

# Unknown keys return HTTP 200 and {"team": null, "org": null}. Fail the plan
# in that case so a typo cannot apply unowned tags.
resource "terraform_data" "require_owner" {
  lifecycle {
    precondition {
      condition = (
        local.decoded != null &&
        (var.allow_unregistered || local.has_owner)
      )
      error_message = "Service registry has no team and org for ${var.service_key}. Use the exact services.json key, or set allow_unregistered only for a documented exception."
    }
  }
}
