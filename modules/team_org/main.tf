locals {
  team = lookup(jsondecode(data.http.team_org.body), "team", null)
  org  = lookup(jsondecode(data.http.team_org.body), "org", null)

  team_to_search = coalesce(var.team, "NULL") # guaranteed non-empty string
  team_encoded   = urlencode(local.team_to_search)
}

data "http" "team_org" {
  url = "${var.api_endpoint}/v1/team_org/${local.team_encoded}"

  # The following attributes are exported: body (the raw body of the HTTP response)
}
