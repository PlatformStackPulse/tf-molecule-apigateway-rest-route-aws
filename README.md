# tf-molecule-apigateway-rest-route-aws

Terraform molecule that creates a complete API Gateway REST route with Lambda integration.

## Components (Atoms)

- `tf-atom-apigateway-resource-aws` — API Gateway resource (path)
- `tf-atom-apigateway-method-aws` — HTTP method configuration
- `tf-atom-apigateway-integration-aws` — Lambda proxy integration
- `tf-atom-lambda-permission-aws` — Lambda invoke permission for API Gateway

## Usage

```hcl
module "route_contact" {
  source = "git::https://github.com/PlatformStackPulse/tf-molecule-apigateway-rest-route-aws.git?ref=main"

  context            = module.this.context
  rest_api_id        = module.rest_api.rest_api_id
  parent_resource_id = module.rest_api.root_resource_id
  path_part          = "contact"
  integration_uri    = module.lambda_functions["contact-form"].invoke_arn
  function_name      = module.lambda_functions["contact-form"].function_name
  execution_arn      = module.rest_api.execution_arn
}

# Nested route (child of contact)
module "route_contact_id" {
  source = "git::https://github.com/PlatformStackPulse/tf-molecule-apigateway-rest-route-aws.git?ref=main"

  context            = module.this.context
  rest_api_id        = module.rest_api.rest_api_id
  parent_resource_id = module.route_contact.resource_id
  path_part          = "{id}"
  integration_uri    = module.lambda_functions["contact-form"].invoke_arn
  function_name      = module.lambda_functions["contact-form"].function_name
  execution_arn      = module.rest_api.execution_arn
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| rest_api_id | ID of the REST API | string | - | yes |
| parent_resource_id | Parent resource ID | string | - | yes |
| path_part | Route path segment | string | - | yes |
| http_method | HTTP method | string | "ANY" | no |
| authorization | Auth type | string | "NONE" | no |
| authorizer_id | Authorizer ID | string | null | no |
| integration_uri | Lambda invoke ARN | string | - | yes |
| function_name | Lambda function name | string | - | yes |
| execution_arn | API execution ARN | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| resource_id | API Gateway resource ID |
| method_http_method | HTTP method |
| integration_uri | Integration URI |
