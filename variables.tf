variable "user_uuid" {
  type        = string
  description = "The Terraform BootCamp UUID"

  validation {
    condition     = length(var.user_uuid) > 5
    error_message = "User UUID provided is not VALID, please check!!!"
  }
}