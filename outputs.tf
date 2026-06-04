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
