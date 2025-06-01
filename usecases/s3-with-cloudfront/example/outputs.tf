output "cf_endpoint" {
  value = module.s3_with_cf.cloudfront_domain_name
}
