output "bucket_name" {
  value = aws_s3_bucket.vault.bucket
}

output "kms_key_arn" {
  value = aws_kms_key.vault_key.arn
}