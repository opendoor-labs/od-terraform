module "s3_test_versioning" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-versioning"
  region = var.region

  versioning = var.versioning_enabled

  team = "cloud-infra"
  env  = "staging"

  custom_tags = local.custom_tags
}
