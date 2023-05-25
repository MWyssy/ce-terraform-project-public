variable "init" {
  description = "Determine whether to create initial s3 and dynamoDB for remote store"
  type        = bool
}

variable "remote_name" {
  description = "Name of the remote store bucket"
  type        = string
  default     = "ce-tf-remote-store"
}

variable "dydb_name" {
  description = "Name of the remote store bucket"
  type        = string
  default     = "remote-lock"
}
