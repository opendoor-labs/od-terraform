variable "team" {
  type        = string
  default     = null
  description = "Team to lookup in service registry {team.key}"
}

variable "api_endpoint" {
  type        = string
  description = "The API endpoint for OD 'serviceregistry' service"
}
