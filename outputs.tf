output "bucket_name" {
  description = "This is our bucket for static website hosting"
  value = module.terrahous_aws.bucket_name
}

output "s3_static_website_endpoint" {
  description = "This will output S3 Static Website Endpoint"
  value = module.terrahous_aws.s3_static_website_endpoint
}
