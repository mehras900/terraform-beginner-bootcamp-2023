variable "user_uuid" {
  type        = string
  description = "The Terraform BootCamp UUID"

  validation {
    condition     = length(var.user_uuid) > 5
    error_message = "User UUID provided is not VALID, please check!!!"
  }
}

variable "bucket_name" {
  description = "The name of the S3 bucket, should be all lowercase."
  type        = string
  validation {
    condition     = !can(regex("[A-Z]", var.bucket_name))
    error_message = "The bucket_name must not contain uppercase letters."
  }
}


variable "index_html_filepath" {
  description = "The path of the file to check."
  type        = string

  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The index.html file does not exist."
  }
}

variable "error_html_filepath" {
  description = "The path of the file to check."
  type        = string

  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The error.html file does not exist."
  }
}


variable "content_version" {
type = number
description = "Content version mumber, should start from 1"
validation {
  error_message = "Content version is not of a type 'number'"
  condition = var.content_version > 0 && floor(var.content_version) == var.content_version
}

}

# floor returns the closest whole number that is less than or equal to the given value, which may be a fraction.

variable "assets_path" {
  description = "This is the path to the assets folder"
  type = string
}