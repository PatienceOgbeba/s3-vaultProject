variable "bucket_arn" {}
variable "bucket_name" {}

resource "aws_guardduty_detector" "main" {
  enable = true
}