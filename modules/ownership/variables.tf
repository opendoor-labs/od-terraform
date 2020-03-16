variable "service_key" {
  type        = string
  default     = null
  description = "The canonical key for your service, which will be used to look up ownership in service registry. (e.g. \"roll-call\", not \"Roll Call\")"
}

variable "serviceregistry_api" {
  type        = string
  description = "The API endpoint for OD 'serviceregistry' service"
}
