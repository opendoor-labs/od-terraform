run "registered_service" {
  command = plan

  variables {
    service_key = "web"
    env         = "production"
    repo        = "opendoor-labs/aws-baseline"
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "{\"team\":\"buyer\",\"org\":\"consumer\"}"
    }
  }

  assert {
    condition     = output.team == "buyer" && output.org == "consumer" && output.service == "web"
    error_message = "Expected team, org, and service from the registry response."
  }

  assert {
    condition = output.tags == {
      org          = "consumer"
      team         = "buyer"
      service      = "web"
      env          = "production"
      "managed-by" = "terraform"
      repo         = "opendoor-labs/aws-baseline"
    }
    error_message = "Expected the six canonical tags."
  }
}

run "shared_resource_omits_env" {
  command = plan

  variables {
    service_key = "aws-baseline"
    env         = null
    repo        = "opendoor-labs/aws-baseline"
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "{\"team\":\"infra\",\"org\":\"infra\"}"
    }
  }

  assert {
    condition     = !contains(keys(output.tags), "env")
    error_message = "A null env must be omitted from tags."
  }

  assert {
    condition     = output.tags["team"] == "infra" && output.tags["org"] == "infra"
    error_message = "Shared resources still take team and org from the registry."
  }
}

run "encodes_service_key" {
  command = plan

  variables {
    service_key = "service registry"
    env         = "staging"
    repo        = "opendoor-labs/aws-baseline"
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "{\"team\":\"infra\",\"org\":\"infra\"}"
    }
  }

  assert {
    condition     = output.service_owner_url == "https://serviceregistry-api-nginx-private-http.apps.internal.opendoor.com/v1/service_owner/service%20registry"
    error_message = "Spaces in the service key must be percent-encoded in the path."
  }
}

run "unknown_service_fails" {
  command = plan

  variables {
    service_key = "not-a-real-service"
    env         = "production"
    repo        = "opendoor-labs/aws-baseline"
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "{\"team\":null,\"org\":null}"
    }
  }

  expect_failures = [
    terraform_data.require_owner,
  ]
}

run "empty_owner_fails" {
  command = plan

  variables {
    service_key = "blank-owner"
    env         = "production"
    repo        = "opendoor-labs/aws-baseline"
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "{\"team\":\"\",\"org\":\"infra\"}"
    }
  }

  expect_failures = [
    terraform_data.require_owner,
  ]
}

run "malformed_json_fails" {
  command = plan

  variables {
    service_key = "web"
    env         = "production"
    repo        = "opendoor-labs/aws-baseline"
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "not-json"
    }
  }

  expect_failures = [
    terraform_data.require_owner,
  ]
}

run "non_200_fails" {
  command = plan

  variables {
    service_key = "web"
    env         = "production"
    repo        = "opendoor-labs/aws-baseline"
    # The data source postcondition fails before the owner check.
    allow_unregistered = true
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 503
      response_body = "unavailable"
    }
  }

  expect_failures = [
    data.http.service_owner,
  ]
}

run "allow_unregistered_omits_empty_owner" {
  command = plan

  variables {
    service_key        = "shared-bucket"
    env                = "production"
    repo               = "opendoor-labs/aws-baseline"
    allow_unregistered = true
  }

  override_data {
    target = data.http.service_owner
    values = {
      status_code   = 200
      response_body = "{\"team\":null,\"org\":null}"
    }
  }

  assert {
    condition     = output.team == null && output.org == null
    error_message = "An unregistered key should not invent team or org."
  }

  assert {
    condition     = !contains(keys(output.tags), "team") && !contains(keys(output.tags), "org")
    error_message = "Null team and org must be omitted from tags."
  }

  assert {
    condition = output.tags == {
      service      = "shared-bucket"
      env          = "production"
      "managed-by" = "terraform"
      repo         = "opendoor-labs/aws-baseline"
    }
    error_message = "Unregistered mode should still emit the caller-supplied tags."
  }
}
