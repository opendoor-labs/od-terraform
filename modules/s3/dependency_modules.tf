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
