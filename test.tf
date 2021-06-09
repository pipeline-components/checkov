
# Create an S3 bucket for deployments
resource "aws_s3_bucket" "abucket" {
  bucket = "abucket"

  acl     = "private"
  
  versioning {
      enabled = true # needed for pipeline source
  }

  lifecycle_rule {
    id      = "autodelete"
    enabled = true

    expiration {
      days = 7
    }
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "abucket" {
  bucket = aws_s3_bucket.abucket.id

  block_public_acls   = true
  block_public_policy = true
}