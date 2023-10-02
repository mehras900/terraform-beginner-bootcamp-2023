output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "s3_static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}