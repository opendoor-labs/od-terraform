module "s3_test_logging" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-logging"
  region = var.region

  acl_grants = [var.logging_grant]

  logging = {
    target_bucket = "od-test-logging"
    target_prefix = "logs/"
  }

  team = "cloud-infra"
  env  = "development"
  app  = "test-logging"

  custom_tags = local.custom_tags
}
