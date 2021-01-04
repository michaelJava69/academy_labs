resource "aws_s3_bucket" "this" {
  bucket = "javans-terraform-bucket"

  tags = {
    Name = "mybucket"
  }
}

