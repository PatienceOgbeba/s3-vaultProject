variable "bucket_arn" {}
variable "bucket_name" {}
variable "alert_email" {}

resource "aws_s3_bucket" "trail_logs" {
  bucket = "${var.bucket_name}-trail-logs"
}

resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.trail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AWSCloudTrailWrite",
        Effect: "Allow",
        Principal: {
          Service: "cloudtrail.amazonaws.com"
        },
        Action: "s3:PutObject",
        Resource: "${aws_s3_bucket.trail_logs.arn}/AWSLogs/*",
        Condition: {
          StringEquals: {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      },
      {
        Sid: "AWSCloudTrailAclCheck",
        Effect: "Allow",
        Principal: {
          Service: "cloudtrail.amazonaws.com"
        },
        Action: "s3:GetBucketAcl",
        Resource: aws_s3_bucket.trail_logs.arn
      }
    ]
  })
}
resource "aws_cloudtrail" "vault_trail" {
  name                       = "vault-trail"
  s3_bucket_name             = aws_s3_bucket.trail_logs.id
  enable_logging             = true
  enable_log_file_validation = true
  is_multi_region_trail      = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${var.bucket_arn}/"]
    }
  }
}

resource "aws_sns_topic" "alerts" {
  name = "vault-security-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "delete_attempt" {
  name = "vault-delete-alert"

  event_pattern = jsonencode({
    source = ["aws.s3"],
    detail-type = ["AWS API Call via CloudTrail"],
    detail = {
      eventName = ["DeleteObject", "DeleteObjectVersion"]
      requestParameters = {
        bucketName = [var.bucket_name]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule = aws_cloudwatch_event_rule.delete_attempt.name
  arn  = aws_sns_topic.alerts.arn
}