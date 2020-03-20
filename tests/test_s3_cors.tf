module "s3_test_bucket_cores" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-cors-rules"
  region = var.region

  cors_rules = [var.cors_get_any]

  team = "cloud-infra"
  env  = "staging"

  custom_tags = local.custom_tags
}
