variable "service_key" {
  type        = string
  description = "Exact service registry key (services.json key), for example web, not a display name."

  validation {
    condition     = length(trimspace(var.service_key)) > 0
    error_message = "service_key must be a non-empty service registry key."
  }
}

variable "env" {
  type        = string
  default     = null
  nullable    = true
  description = "Deployment environment. Omit only for a resource that is genuinely shared across environments."

  validation {
    condition     = var.env == null || try(length(trimspace(var.env)) > 0, false)
    error_message = "env must be null or a non-empty string."
  }
}

variable "repo" {
  type        = string
  description = "GitHub repo that manages the resource, as opendoor-labs/<repo>."

  validation {
    condition     = startswith(var.repo, "opendoor-labs/") && length(var.repo) > length("opendoor-labs/")
    error_message = "repo must be opendoor-labs/<repo>."
  }
}

variable "managed_by" {
  type        = string
  default     = "terraform"
  description = "Value for the managed-by tag."

  validation {
    condition     = length(trimspace(var.managed_by)) > 0
    error_message = "managed_by must be a non-empty string."
  }
}

variable "serviceregistry_api" {
  type        = string
  default     = "https://serviceregistry-api-nginx-private-http.apps.internal.opendoor.com"
  description = "Service registry base URL. Terrakube must be able to reach it at plan time."

  validation {
    condition     = startswith(var.serviceregistry_api, "https://")
    error_message = "serviceregistry_api must be an https URL."
  }
}

variable "allow_unregistered" {
  type        = bool
  default     = false
  description = "When true, an HTTP 200 with null team or org still plans, and those keys are omitted from tags. Non-200 responses and malformed JSON still fail. Leave false except for a documented shared resource that is not in the registry."
}
