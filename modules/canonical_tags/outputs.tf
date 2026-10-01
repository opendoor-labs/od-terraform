output "service" {
  description = "Service registry key passed in. This is the service tag."
  value       = var.service_key
}

output "team" {
  description = "Team from the service registry. Null only when allow_unregistered is true and the key has no owner."
  value       = local.has_owner ? local.team : null
}

output "org" {
  description = "Org from the service registry. Null only when allow_unregistered is true and the key has no owner."
  value       = local.has_owner ? local.org : null
}

output "tags" {
  description = "Canonical AWS tags. Merge this map last so org, team, and service win over caller tags."
  value       = local.tags
}

output "service_owner_url" {
  description = "Service registry URL requested for this key."
  value       = local.service_owner_url
}
