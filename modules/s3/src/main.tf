resource "aws_s3_bucket" "bucket" {
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "versioning_configuration" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  count         = var.log_config.enable ? 1 : 0
  bucket_prefix = var.log_config.log_bucket_prefix

}

# resource "aws_s3_bucket_acl" "log_bucket_acl" {
#   count  = var.log_config.enable ? 1 : 0
#   bucket = aws_s3_bucket.log_bucket[0].id
#   acl    = "log-delivery-write"
# }


resource "aws_s3_bucket_policy" "log_bucket_policy" {
  count  = var.log_config.enable ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowS3Logging",
        Effect    = "Allow",
        Principal = { Service = "logging.s3.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.log_bucket[0].arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_logging" "log_config" {
  count         = var.log_config.enable ? 1 : 0
  bucket        = aws_s3_bucket.bucket.id
  target_bucket = aws_s3_bucket.log_bucket[0].id
  target_prefix = "log/"

}
