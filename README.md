# od-terraform
Shared terraform modules

This repo contains shared terraform modules that could be easily imported
into different private github Opendoor projects by standard terraform mechanism
described [here](https://www.terraform.io/docs/modules/sources.html#github)

```
module "ownership" {
  source = "github.com/opendoor-labs/od-terraform/modules/ownership"
}
```

This repo is not designed to be "public" in its true sense.

It simplifies access to terraform shared modules from different systems, such
as CI/CD (on-prem or cloud), local testing by developers via `terrafom plan` and so on.

The terraform modules stored in this public repo do not contain any Opendoor-specific
secrets or other internal implementation details. All private data is simply passed
via terraform variables.
