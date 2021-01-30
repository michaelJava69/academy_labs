variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique.  : terraform-s3-bucket-azuka"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account.  : terraform-s3-bucket-azuka-locks"
  type        = string
}
