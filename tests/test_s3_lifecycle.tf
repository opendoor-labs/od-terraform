module "s3_test_lifecycle" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-lifecycle"
  region = var.region

  lifecycle_rules = [
    jsondecode(templatefile(
      "${path.module}/templates/lifecycle_expiration.tmpl",
      { prefix = "", days = 30, noncurrent_days = 1 }
    )),
    jsondecode(templatefile(
      "${path.module}/templates/lifecycle_transition.tmpl",
      { prefix = "", days = 3, tier = "INTELLIGENT_TIERING" }
    ))
  ]

  team = "cloud-infra"
  env  = "development"
  app  = "test-lifecycle"

  custom_tags = local.custom_tags
}
