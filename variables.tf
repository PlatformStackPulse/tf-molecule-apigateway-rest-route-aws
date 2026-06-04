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
