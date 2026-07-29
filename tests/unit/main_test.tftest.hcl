# Unit tests for tf-molecule-apigateway-rest-route-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test
# Run verbose:      terraform test -verbose
# Run specific:     terraform test -run "creates_when_enabled"

mock_provider "aws" {}

# Sample inputs valid for every run block. tf-label labels plus the
# molecule's own required inputs (rest_api_id, parent_resource_id, path_part,
# integration_uri, function_name, execution_arn).
variables {
  namespace = "eg"
  stage     = "test"
  name      = "route"

  rest_api_id        = "abc123def4"
  parent_resource_id = "root567xyz"
  path_part          = "contact"
  http_method        = "POST"
  integration_uri    = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:eg-test-contact/invocations"
  function_name      = "eg-test-contact"
  execution_arn      = "arn:aws:execute-api:us-east-1:123456789012:abc123def4"
}

# ---------------------------------------------------------------------------
# Test: molecule wires up the route when enabled (default).
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  # method_http_method and integration_uri are derived from inputs, so they are
  # known at plan time (resource_id is a computed API Gateway id, unknown until
  # apply, so it is asserted only in the disabled case below).
  assert {
    condition     = output.method_http_method == "POST"
    error_message = "method_http_method output should reflect the requested http_method"
  }

  assert {
    condition     = output.integration_uri == var.integration_uri
    error_message = "integration_uri output should echo the integration_uri input"
  }
}

# ---------------------------------------------------------------------------
# Test: a nested path (parent = another route's resource_id) plans cleanly and
# still exposes the requested method.
# ---------------------------------------------------------------------------
run "nested_path_plans" {
  command = plan

  variables {
    path_part          = "{id}"
    parent_resource_id = "child987abc"
    http_method        = "GET"
  }

  assert {
    condition     = output.method_http_method == "GET"
    error_message = "method_http_method output should reflect the nested route http_method"
  }
}

# ---------------------------------------------------------------------------
# Test: the OPTIONS preflight advertises Idempotency-Key by default.
#
# This is a regression test for a full outage, not a style preference. A client
# that mints replay keys sends `Idempotency-Key` on every mutation; when the
# MOCK preflight omitted it, the browser refused EVERY cross-origin POST/PUT/
# PATCH/DELETE before it left the page — login, register, checkout — and the
# failure looked like a network error, so nothing in the API's logs showed it.
# The header list is baked into the mock response, so no runtime code can
# compensate: if this assertion goes red, the fix belongs here.
# ---------------------------------------------------------------------------
run "preflight_allows_idempotency_key_by_default" {
  command = plan

  assert {
    condition     = strcontains(output.cors_allowed_headers, "Idempotency-Key")
    error_message = "the default preflight header list must allow Idempotency-Key"
  }

  assert {
    condition     = aws_api_gateway_integration_response.options_200.response_parameters["method.response.header.Access-Control-Allow-Headers"] == "'${var.cors_allowed_headers}'"
    error_message = "the OPTIONS integration response must return the configured header list"
  }
}

# ---------------------------------------------------------------------------
# Test: a caller can narrow or extend the preflight header list.
# ---------------------------------------------------------------------------
run "preflight_headers_are_configurable" {
  command = plan

  variables {
    cors_allowed_headers = "Content-Type,X-Tenant-Id"
    cors_allowed_methods = "GET,OPTIONS"
  }

  assert {
    condition     = aws_api_gateway_integration_response.options_200.response_parameters["method.response.header.Access-Control-Allow-Headers"] == "'Content-Type,X-Tenant-Id'"
    error_message = "cors_allowed_headers should drive the OPTIONS integration response"
  }

  assert {
    condition     = aws_api_gateway_integration_response.options_200.response_parameters["method.response.header.Access-Control-Allow-Methods"] == "'GET,OPTIONS'"
    error_message = "cors_allowed_methods should drive the OPTIONS integration response"
  }
}
