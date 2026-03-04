output "vault_bucket_name" {
  description = "Name of the immutable legal vault bucket"
  value       = module.vault.bucket_name
}

output "vault_bucket_arn" {
  description = "ARN of the legal vault bucket"
  value       = module.vault.bucket_arn
}

output "kms_key_arn" {
  description = "KMS Key ARN used for encryption"
  value       = module.vault.kms_key_arn
}

output "vpc_endpoint_id" {
  description = "S3 VPC Endpoint ID enforcing Zero Trust access"
  value       = module.network.s3_vpc_endpoint_id
}

output "sns_alert_topic_arn" {
  description = "SNS topic for security alerts"
  value       = module.monitoring.sns_topic_arn
}

output "cloudtrail_name" {
  description = "CloudTrail trail monitoring the vault"
  value       = module.monitoring.cloudtrail_name
}