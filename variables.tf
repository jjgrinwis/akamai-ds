# ============================================
# Property Selection Variables
# ============================================

variable "property_names" {
  description = "List of Akamai property names to include in the datastream. If empty, all properties from the group will be used."
  type        = list(string)
  default     = []
}

# ============================================
# Akamai Account Configuration
# ============================================

variable "group_name" {
  description = "The Akamai Control Center group name where Datastream resource will be created. Also used to look up properties, contract and group IDs."
  type        = string
  default     = "acc_group"
}

# ============================================
# DataStream Configuration
# ============================================

variable "stream_name" {
  default = "The name of the datastream."
  type    = string
}

variable "interval_in_secs" {
  description = "Delivery frequency interval in seconds. Must be 30 or 60."
  type        = number
  default     = 60

  validation {
    condition     = contains([30, 60], var.interval_in_secs)
    error_message = "interval_in_secs must be either 30 or 60 seconds."
  }
}

variable "notification_emails" {
  description = "List of email addresses to receive notifications about the datastream."
  type        = list(string)
  default     = ["admin@example.com"]
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

# ============================================
# HTTPS Connector Credentials (Sensitive)
# ============================================
# These should be set via environment variables (TF_VAR_*) or secret management
# Never commit these values to version control

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
