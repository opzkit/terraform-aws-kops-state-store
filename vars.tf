variable "state_store_name" {
  type        = string
  description = "Name of the bucket to be created"
}

variable "clusters" {
  type        = list(string)
  description = "Cluster names to use for backup removal lifecycle rule"
}
