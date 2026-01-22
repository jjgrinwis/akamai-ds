output "datastream_property_ids" {
  description = "The property IDs included in the datastream (matches the properties actually used)."
  value = length(var.property_names) > 0 ? [
    for p in values(data.akamai_property.properties_by_name) : tonumber(replace(p.property_id, "prp_", ""))
    ] : [
    for p in data.akamai_properties.my_properties.properties : tonumber(replace(p.property_id, "prp_", ""))
  ]
}
