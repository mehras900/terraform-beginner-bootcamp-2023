# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
# resource "random_string" "bucket_name" {
#   length  = 32
#   special = false
#   lower = true
#   upper = false

#   # lifecycle {
#   #   ignore_changes = [
#   #     special,
#   #     upper
#   #   ]
#   # }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    UserUUID = var.user_uuid
    managedBy = "terraform"
  }
}



