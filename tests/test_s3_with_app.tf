module "s3_test_bucket_with_app" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-with-app-tag"
  region = var.region

  app = "echo" # just using some app that belongs to cloud-infra team
  env = "staging"

  custom_tags = local.custom_tags
}
