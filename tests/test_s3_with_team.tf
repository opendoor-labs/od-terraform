module "s3_test_bucket_with_team" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-with-team-tag"
  region = var.region

  team = "cloud-infra"
  env  = "development"
  app  = "test-with-team-tag"

  custom_tags = local.custom_tags
}
