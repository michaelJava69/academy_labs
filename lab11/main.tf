


locals {
  tags = {
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = var.expiration_date 
  }
}


##  create s3 bucket to be used as backend

resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags

}


## create DynanamoDB table responsible for locking

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"


  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags

}

