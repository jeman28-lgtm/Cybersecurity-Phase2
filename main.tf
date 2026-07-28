provider "aws" {  
  region = "us-east-1"  
}  

# ------------------------------------------------------------------
# Main Application Bucket
# ------------------------------------------------------------------
resource "aws_s3_bucket" "lab_bucket" {
  bucket = "my-secure-company-bucket-lab"
}

# 1. Block all public access completely
resource "aws_s3_bucket_public_access_block" "lab_bucket_privacy" {
  bucket                  = aws_s3_bucket.lab_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Enable KMS Server-Side Encryption (fixes aws-s3-encryption-customer-key)
resource "aws_s3_bucket_server_side_encryption_configuration" "lab_bucket_crypto" {
  bucket = aws_s3_bucket.lab_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
      sse_algorithm     = "aws:kms"
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

# 4. Enable Access Logging (fixes aws-s3-enable-bucket-logging)
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-secure-company-bucket-logs"
}

resource "aws_s3_bucket_logging" "lab_bucket_logging" {
  bucket        = aws_s3_bucket.lab_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}