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

module "terrahous_aws" {
  source = "./modules/terrahous_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}



