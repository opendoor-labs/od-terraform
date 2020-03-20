module "s3_test_bucket_encryption" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-encryption"
  region = var.region

  server_side_encryption = "AES256"

  team = "cloud-infra"
  env  = "staging"

  custom_tags = local.custom_tags
}
