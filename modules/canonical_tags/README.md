# Canonical tags

Looks up a service in the service registry and returns the canonical AWS tag map:

`org`, `team`, `service`, `env`, `managed-by`, `repo`.

`modules/ownership` is the older lookup. It returns null team and org when the key is missing, and `modules/s3` imports it without a version pin. This module does not change that. New callers should use this path. It fails the plan when the registry has no owner.

```hcl
module "canonical_tags" {
  source = "git::https://github.com/opendoor-labs/od-terraform.git//modules/canonical_tags?ref=master"

  service_key = "web"
  env         = "production"
  repo        = "opendoor-labs/aws-baseline"
}

resource "aws_s3_bucket" "documents" {
  bucket = "web-documents-production"

  # Canonical tags last, so a local map cannot override org, team, or service.
  tags = merge(local.extra_tags, module.canonical_tags.tags)
}
```

Leave `env` unset only when the resource is shared across environments. `managed_by` defaults to `terraform`. `serviceregistry_api` defaults to the private service-registry URL.

Unknown keys come back as HTTP 200 and `{"team": null, "org": null}`. This module fails the plan in that case, and also on non-200 responses and malformed JSON. `allow_unregistered` defaults to false.

```bash
terraform -chdir=modules/canonical_tags init -backend=false
terraform -chdir=modules/canonical_tags test
```
