resource "aws_s3_bucket" "state_store" {
  bucket        = var.state_store_name
  force_destroy = true

  tags = {
    Name = "kops state store"
  }
}

resource "aws_s3_bucket_acl" "state_store" {
  bucket = aws_s3_bucket.state_store.id
  acl    = "private"
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
