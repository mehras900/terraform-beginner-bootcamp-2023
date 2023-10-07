

# Create S3 Bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    UserUUID = var.user_uuid
    managedBy = "terraform"
  }
}

# Enable Static Website Hosting in S3 bucket
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# https://developer.hashicorp.com/terraform/language/resources/terraform-data
resource "terraform_data" "content_version" {
  input = var.content_version
}

# Upload index.html and error.html files to bucket

/*
The filemd5() function is available in Terraform 0.11.12 and later
For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
etag = "${md5(file("path/to/file"))}"
*/

resource "aws_s3_object" "index_html_object" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  content_type = "text/html"
  source = var.index_html_filepath
  etag = filemd5(var.index_html_filepath)

  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "error_html_object" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  content_type = "text/html"
  source = var.error_html_filepath
  etag = filemd5(var.error_html_filepath)

  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}


# Create bucket policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "cloudfront.amazonaws.com"
      },
      "Action" = "s3:GetObject",
      "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
      "Condition" = {
      "StringEquals" = {
          #"AWS:SourceArn": data.aws_caller_identity.current.arn
          "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.terrahouse_distribution.id}"
        }
      }
    }
  })
}

resource "aws_s3_object" "upload_assests" {
  for_each = fileset("${var.assets_path}/fun-images", "*.{gif,jpg,png}")
  bucket = aws_s3_bucket.website_bucket.id
  key    = "assets/fun-images/${each.key}"
  # content_type = "image/gif"
  source = "${var.assets_path}/fun-images/${each.key}"
  etag = filemd5("${var.assets_path}/fun-images/${each.key}")

  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
