data "cloudflare_zones" "domain" {
  filter {
    name = var.domain
  }
}

resource "cloudflare_record" "record" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.subdomain
  content = var.ip
  type    = "A"
  ttl     = 1
  proxied = var.proxied

  lifecycle {
    create_before_destroy = true
  }
}
