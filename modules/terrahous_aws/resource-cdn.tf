
locals {
  s3_origin_id = "terrahouse-S3Origin"
}

# Create CDN DISTRIBUTION
resource "aws_cloudfront_origin_access_control" "terrahouse_oac" {
  name                              = "terrahouse_oac"
  description                       = "Origin Access Control for Terrahouse CloudFront Distribution for bucket: ${var.bucket_name} "
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "terrahouse_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.terrahouse_oac.id
    origin_id                = local.s3_origin_id
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Terrahouse CloudFront Distribution for ${var.bucket_name}"
  default_root_object = "index.html"
  http_version        = "http2"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

   
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    UserUUID = var.user_uuid,
    managedBy = "terraform"
  }

  price_class = "PriceClass_All"

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html
# https://developer.hashicorp.com/terraform/language/resources/terraform-data
resource "terraform_data" "invalidating_cache" {
  triggers_replace = [
    terraform_data.content_version.output
  ]

  provisioner "local-exec" {
    command = <<EOT
aws cloudfront create-invalidation \
--distribution-id ${aws_cloudfront_distribution.terrahouse_distribution.id} \
--paths '/*'
   EOT

  }
}