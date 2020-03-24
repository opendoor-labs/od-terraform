module "s3_test_bucket_website" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-website"
  region = var.region

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  team = "cloud-infra"
  env  = "staging"

  custom_tags = local.custom_tags
}
