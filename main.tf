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

  rule {
    id     = "Remove backups older than 60 days"
    status = "Enabled"

    filter {
      prefix = "**/backups"
    }

    expiration {
      days                         = 60
      expired_object_delete_marker = false
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_store" {
  bucket = aws_s3_bucket.state_store.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_store" {
  bucket = aws_s3_bucket.state_store.id
  versioning_configuration {
    status = "Enabled"
  }
}
