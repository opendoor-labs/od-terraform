output "team" {
  value       = local.team
  description = "Canonical team name from service registry"
}

output "org" {
  value       = local.org
  description = "The org (EPOD) from service registry associated with canonical team"
}
