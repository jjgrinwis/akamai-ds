output "property_ids" {
  description = "The IDs of the Akamai properties included in the datastream."
  value       = [for p in values(data.akamai_property.properties_by_name) : tonumber(replace(try(p.property_id, p.id), "prp_", ""))]
}
