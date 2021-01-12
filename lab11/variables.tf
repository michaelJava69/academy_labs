variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table used to store the locks. Must be unique per AWS account."
  type        = string
}

variable "capgemini_email" {
  description = "The email address used to tag the resources created for this lab"
  type        = string
}

variable "expiration_date" {
  description = "The expiration date used to tag the resources created for this lab"
  type        = string
}

