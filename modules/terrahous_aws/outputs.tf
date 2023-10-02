output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "s3_static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}


# output "cdn_distribution_arn" {
#   value = aws_cloudfront_distribution.terrahouse_distribution.arn
# }

output "cdn_distribution_domain_name" {
  value = aws_cloudfront_distribution.terrahouse_distribution.domain_name
}
