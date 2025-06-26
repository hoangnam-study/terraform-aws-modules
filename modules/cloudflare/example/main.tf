module "cloudflare" {
  source    = "../src"
  domain    = "dinhhoangnam.io.vn"
  subdomain = "test"
  ip        = "123.123.123.123"
}
