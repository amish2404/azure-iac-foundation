variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "indiasouthcentral"
}

variable "resource_group_name" {
  type    = string
  default = "rg-iac-tf-dev"
}

variable "storage_prefix" {
  type        = string
  description = "Lowercase letters/numbers only, max 16 chars"
  default     = "stiacdev"
}

variable "tags" {
  type = map(string)
  default = {
    env     = "dev"
    project = "iac-foundation"
  }
}