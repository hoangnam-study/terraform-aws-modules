module "s3_with_cf" {
  source           = "../src"
  s3-bucket-prefix = "my-static-website-"

}
