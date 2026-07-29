variable "rest_api_id" {
  description = "ID of the REST API"
  type        = string
}

variable "parent_resource_id" {
  description = "ID of the parent resource (root or another resource)"
  type        = string
}

variable "path_part" {
  description = "Path part for this route (e.g., 'contact', '{id}')"
  type        = string
}

variable "http_method" {
  description = "HTTP method (GET, POST, PUT, DELETE, ANY)"
  type        = string
  default     = "ANY"
}

variable "authorization" {
  description = "Authorization type (NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)"
  type        = string
  default     = "NONE"
}

variable "authorizer_id" {
  description = "Authorizer ID (required when authorization is CUSTOM or COGNITO_USER_POOLS)"
  type        = string
  default     = null
}

variable "integration_uri" {
  description = "Lambda invoke ARN for the integration"
  type        = string
}

variable "function_name" {
  description = "Lambda function name (for permission resource)"
  type        = string
}

variable "execution_arn" {
  description = "API Gateway execution ARN (for permission source_arn scope)"
  type        = string
}

# -----------------------------------------------------------------------------
# CORS preflight
#
# The OPTIONS method below is answered by a MOCK integration, so these values are
# baked into the API Gateway response — a Lambda never sees the preflight and
# cannot widen them at runtime. A custom request header the browser is not told
# about here is REFUSED before the real request is ever sent, which surfaces to
# the caller as an opaque network failure rather than an HTTP status.
#
# The default therefore carries the headers a JSON API over Lambda actually
# needs, including `Idempotency-Key`: a client that mints replay keys for its
# mutations sends that header on every POST/PUT/PATCH/DELETE, and listing it
# costs nothing when the handler ignores it. Allowing a header only permits the
# browser to transmit it — authorization is still decided server-side.
# -----------------------------------------------------------------------------
variable "cors_allowed_headers" {
  description = "Comma-separated request headers returned in the OPTIONS preflight's Access-Control-Allow-Headers. Any custom header the client sends must appear here or the browser blocks the request."
  type        = string
  default     = "Content-Type,Authorization,X-Amz-Date,X-Api-Key,Idempotency-Key"
}

variable "cors_allowed_methods" {
  description = "Comma-separated methods returned in the OPTIONS preflight's Access-Control-Allow-Methods."
  type        = string
  default     = "GET,POST,PUT,PATCH,DELETE,OPTIONS"
}
