variable "terratowns_endpoint" {
  type        = string
}

variable "terratowns_access_token" {
  type        = string
}

variable "teacherseat_user_uuid" {
  type        = string
}


# variable "user_uuid" {
#   type        = string
# }

variable "bucket_name" {
  type        = string
}

variable "index_object_path" {
  type        = string
}

variable "error_object_path" {
  type        = string
}

variable "content_version" {
type = number
}

variable "assets_path" {
  description = "This is the path to the assets folder"
  type = string
}