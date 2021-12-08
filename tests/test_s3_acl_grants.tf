module "s3_test_acl_grants" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-acl-grants"
  region = var.region

  acl_grants = [
    var.read_only_grant,
    var.logging_grant,
  ]

  team = "cloud-infra"
  env  = "development"
  app  = "test-acl-grants"

  custom_tags = local.custom_tags
}
