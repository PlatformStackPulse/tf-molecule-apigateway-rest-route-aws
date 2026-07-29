output "resource_id" {
  description = "ID of the created API Gateway resource"
  value       = module.resource.id
}

output "method_http_method" {
  description = "HTTP method of the created method"
  value       = module.method.http_method
}

output "integration_uri" {
  description = "Integration URI"
  value       = var.integration_uri
}

output "cors_allowed_headers" {
  description = "Request headers the OPTIONS preflight advertises as allowed. A client header missing from this list is blocked by the browser before the request is sent."
  value       = var.cors_allowed_headers
}

output "cors_allowed_methods" {
  description = "Methods the OPTIONS preflight advertises as allowed."
  value       = var.cors_allowed_methods
}
