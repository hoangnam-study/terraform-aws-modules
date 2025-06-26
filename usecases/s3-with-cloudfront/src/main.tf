module "s3" {
  source            = "../../../modules/s3/src"
  bucket_prefix     = var.s3-bucket-prefix
  force_destroy     = true
  enable_versioning = true
  log_config = {
    enable            = false
    log_bucket_prefix = null
  }
}

# oac
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "my-oac"
  description                       = "Access to S3 from CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# cloudfront
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = module.s3.bucket.bucket_regional_domain_name
    origin_id                = "s3-website-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-website-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_cloudfront_origin_access_control.oac]
}


# bucket policy
resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = module.s3.bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${module.s3.bucket.id}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "arn:aws:cloudfront::${data.aws_caller_identity.account_id.account_id}:distribution/${aws_cloudfront_distribution.cdn.id}"
          }
        }
      }
    ]
  })
}

