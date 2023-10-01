terraform {
  # cloud {
  #   organization = "tfbootcamp-2023"

  #   workspaces {
  #     name = "terrahouse-1"
  #   }
  # }
  required_providers {

    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    UserUUID = var.user_uuid
    managedBy = "terraform"
  }
}
