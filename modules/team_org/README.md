## Canonical Team/Org pair

This terraform module takes 'team' variable as an input, which
corresponds to canonical team name {team.key} in service registry terms.

The service registry API endpoint is passed as module's variable `api_endpoint`.

It returns {team.key} and {org.key} (EPOD) exported by terraform as `team` and `org` output variables.
