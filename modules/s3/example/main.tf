
module "s3" {
  source            = "../src"
  bucket_prefix     = "my-bucket-"
  force_destroy     = true
  enable_versioning = true
  log_config = {
    enable            = true
    log_bucket_prefix = "log-bucket-"
  }

}
