module "s3_test_bucket_different_region" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-different-region"
  region = "us-west-2"

  team = "cloud-infra"
  env  = "development"
  app  = "test-different-region"

  custom_tags = local.custom_tags
}
