# Molecule: API Gateway REST Route (Resource + Method + Integration + Lambda Permission)
# Creates a complete API Gateway route with Lambda integration in a single module call.

module "resource" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-apigateway-resource-aws.git?ref=351a91d73d68e5334160cd56ed844267e5c89d67"

  context     = module.this.context
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_resource_id
  path_part   = var.path_part
}

module "method" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-apigateway-method-aws.git?ref=2eeef49f20745d13f75515f1a4c776b60163b6db"

  context       = module.this.context
  rest_api_id   = var.rest_api_id
  resource_id   = module.resource.id
  http_method   = var.http_method
  authorization = var.authorization
  authorizer_id = var.authorizer_id

  depends_on = [module.resource]
}

module "integration" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-apigateway-integration-aws.git?ref=c9eedb8907fc0a47be8292f26ea89166546edae4"

  context                 = module.this.context
  rest_api_id             = var.rest_api_id
  resource_id             = module.resource.id
  http_method             = module.method.http_method
  integration_type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.integration_uri

  depends_on = [module.method]
}

module "lambda_permission" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-permission-aws.git?ref=f9cb20f9bfbff65fbc58b9f7eacafc418375aef0"

  context       = module.this.context
  attributes    = [var.path_part]
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.execution_arn}/*/${var.http_method}/${var.path_part}"

  depends_on = [module.integration]
}
