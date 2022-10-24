variable "state_store_name" {
  type        = string
  description = "Name of the bucket to be created"
}

variable "kms_key" {
  type        = string
  description = "Name of the KMS key to use for encryption at rest, or null to use the default aws/s3 AWS KMS master key"
  default     = null
}
