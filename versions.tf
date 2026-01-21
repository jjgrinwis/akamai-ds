terraform {
  # Terraform 1.5+ required for declarative import block support
  required_version = ">= 1.5"
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 9.3.0" # version 9.3.0 for support of the DataStream Decoupling feature
    }
  }
}
