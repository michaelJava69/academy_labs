output "bucket_id" {
  description = "The bucket id"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The bucket arn"
  value       = aws_s3_bucket.this.arn
}

