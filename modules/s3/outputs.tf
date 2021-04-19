output "id" {
  description = "The name of the bucket."
  value       = join("", aws_s3_bucket.s3_bucket.*.id)
}

output "arn" {
  description = "The ARN of the bucket."
  value       = join("", aws_s3_bucket.s3_bucket.*.arn)
}
