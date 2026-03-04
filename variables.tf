variable "region" {
  default = "us-east-1"
}

variable "vault_bucket_name" {
  description = "Globally unique S3 bucket name"
}

variable "alert_email" {
  description = "Security alert email"
}