module "s3_test_with_policy" {
  source              = "../modules/s3"         # local testing by a developer
  serviceregistry_api = var.serviceregistry_api # enter a service registry URI

  bucket = "od-test-with-policy"
  region = var.region

  policy = templatefile(
    "${path.module}/templates/policy_read_public.tmpl",
    { bucket = "od-test-with-policy" }
  )

  team = "cloud-infra"
  env  = "staging"

  custom_tags = local.custom_tags
}

# provider "aws" {
#   region = var.region
# }
#
# resource "aws_s3_bucket" "od-test-with-policy" {
#   bucket = "od-test-with-policy"
#   region = var.region
#   tags = {
#     "Terraform" = "github.com/opendoor-labs/od-terraform/tests"
#     "concern"   = "This is a test bucket: please ignore"
#     "env"       = "staging"
#     "org"       = "infra"
#     "team"      = "cloud-infra"
#   }
# }
#
# resource "aws_s3_bucket_policy" "od-test-with-policy" {
#   bucket = "od-test-with-policy"
#   policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action    = "s3:GetObject"
#           Effect    = "Allow"
#           Principal = "*"
#           Resource  = "arn:aws:s3:::od-test-with-policy/*"
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )
# }
