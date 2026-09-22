locals {
  team = lookup(jsondecode(data.http.team_org.response_body), "team", null)
  org  = lookup(jsondecode(data.http.team_org.response_body), "org", null)

  team_to_search = coalesce(var.team, "NULL") # guaranteed non-empty string
  team_encoded   = urlencode(local.team_to_search)
}

data "http" "team_org" {
  url = "${var.serviceregistry_api}/v1/team_org/${local.team_encoded}"

}
