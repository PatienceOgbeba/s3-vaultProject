output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "cloudtrail_name" {
  value = aws_cloudtrail.vault_trail.name
}