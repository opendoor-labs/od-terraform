variable "team" {
  type        = string
  default     = null
  description = "Team to lookup in service registry {team.key}"
}

variable "serviceregistry_api" {
  type        = string
  description = "The API endpoint for OD 'serviceregistry' service"
}
