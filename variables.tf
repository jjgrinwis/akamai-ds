variable "property_names" {
  description = "List of Akamai property names to include in the datastream."
  type        = list(string)
}
variable "group_name" {
  description = "The Akamai Control Center group name where resources will be created. Used to look up contract and group IDs."
  type        = string
  default     = "acc_group"
}

variable "stream_name" {
  default = "The name of the datastream."
  type    = string
}

variable "notification_emails" {
  description = "List of email addresses to receive notifications about the datastream."
  type        = list(string)
  default     = ["admin@example.com"]
}

variable "https_username" {
  description = "Username for HTTPS connector basic authentication."
  type        = string
  sensitive   = true
}

variable "https_password" {
  description = "Password for HTTPS connector basic authentication."
  type        = string
  sensitive   = true
}

variable "https_endpoint" {
  description = "HTTPS endpoint URL for the datastream connector."
  type        = string
}

variable "sampling_percentage" {
  description = "Percentage of logs to sample for the datastream (1-100). Requires Akamai TF provider >= 9.3.0."
  type        = number
  default     = 100

  validation {
    condition     = var.sampling_percentage >= 1 && var.sampling_percentage <= 100 && floor(var.sampling_percentage) == var.sampling_percentage
    error_message = "sampling_percentage must be an integer between 1 and 100."
  }
}
