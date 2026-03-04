variable "bucket_name" {}
variable "vpc_endpoint_id" {}

resource "aws_kms_key" "vault_key" {
  description             = "Legal Vault Key"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "vault" {
  bucket              = var.bucket_name
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.vault.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "lock" {
  bucket = aws_s3_bucket.vault.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 365
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.vault.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.vault_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.vault.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "zero_trust_policy" {
  bucket = aws_s3_bucket.vault.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
  Sid: "AllowTerraformProvisioning",
  Effect: "Allow",
  Principal: {
    AWS: "arn"
  },
  Action: "s3:*",
  Resource: [
    aws_s3_bucket.vault.arn,
    "${aws_s3_bucket.vault.arn}/*"
  ]
},
      {
        Sid: "DenyInsecureTransport",
        Effect: "Deny",
        Principal: "*",
        Action: "s3:*",
        Resource: [
          aws_s3_bucket.vault.arn,
          "${aws_s3_bucket.vault.arn}/*"
        ],
        Condition: {
          Bool: {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  })
}

output "bucket_arn" {
  value = aws_s3_bucket.vault.arn
}
