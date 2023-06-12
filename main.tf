resource "aws_s3_bucket" "state_store" {
  bucket        = var.state_store_name
  force_destroy = true

  tags = {
    Name = "kops state store"
  }
}

resource "aws_s3_bucket_ownership_controls" "state_store" {
  bucket = aws_s3_bucket.state_store.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "state_store" {
  bucket                  = aws_s3_bucket.state_store.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_lifecycle_configuration" "state_store" {
  bucket = aws_s3_bucket.state_store.id

  rule {
    id     = "Remove versions older than 30 days"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_store" {
  bucket = aws_s3_bucket.state_store.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_store" {
  bucket = aws_s3_bucket.state_store.id
  versioning_configuration {
    status = "Enabled"
  }
}
