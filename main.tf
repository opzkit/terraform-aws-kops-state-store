resource "aws_s3_bucket" "state_store" {
  bucket        = var.state_store_name
  acl           = "private"
  force_destroy = true

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

  tags = {
    Name = "kops state store"
  }

  lifecycle_rule {
    enabled = true
    id      = "Remove versions older than 30 days"
    noncurrent_version_expiration {
      days = 30
    }
  }

  lifecycle_rule {
    enabled = true
    id      = "Remove backups older than 60 days"
    prefix  = "**/backups"
    expiration {
      days                         = 60
      expired_object_delete_marker = false
    }
  }
}
