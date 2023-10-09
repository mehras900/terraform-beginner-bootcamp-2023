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

  # module "terrahous_aws" {
  #   source = "./modules/terrahous_aws"
  #   user_uuid = var.user_uuid
  #   bucket_name = var.bucket_name
  #   index_html_filepath = var.index_object_path
  #   error_html_filepath = var.error_object_path
  #   content_version = var.content_version
  #   assets_path = var.assets_path
  # }

terraform {
    required_providers {
      terratowns = {
        source = "local.providers/local/terratowns"
        version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

resource "terratowns_home" "gta_home" {
  name = "This is the GTA 6 game announcement!!!"
  description = <<DESCRIPTION
    Grand Theft Auto 6 saw what was easily one of the biggest leaks in gaming history.
    Roughly 90 videos were posted onto the official GTA Forums by a poster named teapotuberhacker.
    DESCRIPTION
  # domain_name   = module.terrahous_aws.cdn_distribution_domain_name
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1

}