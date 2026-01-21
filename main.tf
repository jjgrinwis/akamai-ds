# With the new DataStream Decoupling feature, we can now create a datastream independently from the DataStream property behavior.
# NOTE: The DataStream Decoupling feature must be enabled on your Akamai contract to create DataStream-managed integration types.
# This example Terraform configuration demonstrates how to create a datastream that collects data from multiple properties by
# looking up property IDs based on property names.
# 
# This code will create a DataStream-managed integration to send data to a Vector endpoint.
# https://techdocs.akamai.com/datastream2/v3/docs/integration-types

# first lookup the contract info based on group name as we need contract and group IDs to create the datastream.
data "akamai_contract" "my_contract" {
  group_name = var.group_name
}

# We need to look up property IDs based on property names.
# Properties should be available in given group otherwise activation will fail.
data "akamai_property" "properties_by_name" {
  for_each = toset(var.property_names)
  name     = each.value
}

# Create the datastream using the looked up contract, group, and property IDs.
# The current datastream provider doesn't support the new "beta" features. However, the existing resource can still be used to create a DataStream-managed datastreams
# https://techdocs.akamai.com/datastream2/v3/reference/post-stream-cdn
#
# dataset_fields numbers can be found here: https://techdocs.akamai.com/terraform/docs/set-up-datastream#choose-data-sets
# Credentials and endpoint for HTTPS connector should be set via variables in terraform.tfvars, TF_VAR environment variables, or secret management.
resource "akamai_datastream" "my_datastream" {
  active = false
  delivery_configuration {
    format = "JSON"
    frequency {
      interval_in_secs = 60
    }
  }
  contract_id = data.akamai_contract.my_contract.id
  group_id    = data.akamai_contract.my_contract.group_id
  dataset_fields = [
    1000, 1002, 1102, 1066
  ]
  properties  = [for p in values(data.akamai_property.properties_by_name) : tonumber(replace(p.property_id, "prp_", ""))]
  stream_name = var.stream_name
  https_connector {
    authentication_type = "BASIC"
    user_name           = var.https_username
    password            = var.https_password
    endpoint            = var.https_endpoint
    display_name        = "Vector Endpoint to Elastic"
    content_type        = "application/json"
    compress_logs       = true
  }

  notification_emails = var.notification_emails
  collect_midgress    = false

  # Akamai TF provider 9.3.0 required to set sampling_percentage, default 100%
  sampling_percentage = var.sampling_percentage
}
