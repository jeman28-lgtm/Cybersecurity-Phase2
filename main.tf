provider "aws" {  
  region = "us-east-1"  
}  
  
resource "aws_s3_bucket" "lab_bucket" {
  bucket = "my-secure-company-bucket-lab"
}

# 1. Lock down all public access completely
resource "aws_s3_bucket_public_access_block" "lab_bucket_privacy" {
  bucket                  = aws_s3_bucket.lab_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Enable default server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "lab_bucket_crypto" {
  bucket = aws_s3_bucket.lab_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 3. Enable bucket versioning
resource "aws_s3_bucket_versioning" "lab_bucket_versioning" {
  bucket = aws_s3_bucket.lab_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}