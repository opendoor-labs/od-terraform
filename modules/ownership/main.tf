locals {
  team = lookup(jsondecode(data.http.service_owner.body), "team", null)
  org  = lookup(jsondecode(data.http.service_owner.body), "org", null)

  service_to_search = coalesce(var.service_key, "NULL") # guaranteed non-empty string
  service_encoded   = urlencode(local.service_to_search)
}

data "http" "service_owner" {
  url = "${api_endpoint}/v1/service_owner/${local.service_encoded}"

  # The following attributes are exported: body (the raw body of the HTTP response)
}
