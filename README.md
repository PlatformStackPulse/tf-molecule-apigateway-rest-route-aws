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

## Module Documentation

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_integration"></a> [integration](#module\_integration) | git::https://github.com/PlatformStackPulse/tf-atom-apigateway-integration-aws.git | c9eedb8907fc0a47be8292f26ea89166546edae4 |
| <a name="module_lambda_permission"></a> [lambda\_permission](#module\_lambda\_permission) | git::https://github.com/PlatformStackPulse/tf-atom-lambda-permission-aws.git | f9cb20f9bfbff65fbc58b9f7eacafc418375aef0 |
| <a name="module_method"></a> [method](#module\_method) | git::https://github.com/PlatformStackPulse/tf-atom-apigateway-method-aws.git | 2eeef49f20745d13f75515f1a4c776b60163b6db |
| <a name="module_resource"></a> [resource](#module\_resource) | git::https://github.com/PlatformStackPulse/tf-atom-apigateway-resource-aws.git | 351a91d73d68e5334160cd56ed844267e5c89d67 |
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/PlatformStackPulse/tf-label.git | v1.0.0 |

### Resources

| Name | Type |
|------|------|
| [aws_api_gateway_integration.options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.options_200](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.options_200](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_execution_arn"></a> [execution\_arn](#input\_execution\_arn) | API Gateway execution ARN (for permission source\_arn scope) | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name (for permission resource) | `string` | n/a | yes |
| <a name="input_integration_uri"></a> [integration\_uri](#input\_integration\_uri) | Lambda invoke ARN for the integration | `string` | n/a | yes |
| <a name="input_parent_resource_id"></a> [parent\_resource\_id](#input\_parent\_resource\_id) | ID of the parent resource (root or another resource) | `string` | n/a | yes |
| <a name="input_path_part"></a> [path\_part](#input\_path\_part) | Path part for this route (e.g., 'contact', '{id}') | `string` | n/a | yes |
| <a name="input_rest_api_id"></a> [rest\_api\_id](#input\_rest\_api\_id) | ID of the REST API | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_authorization"></a> [authorization](#input\_authorization) | Authorization type (NONE, AWS\_IAM, CUSTOM, COGNITO\_USER\_POOLS) | `string` | `"NONE"` | no |
| <a name="input_authorizer_id"></a> [authorizer\_id](#input\_authorizer\_id) | Authorizer ID (required when authorization is CUSTOM or COGNITO\_USER\_POOLS) | `string` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes and tags, which are merged. | <pre>object({<br/>    enabled             = optional(bool, true)<br/>    namespace           = optional(string, null)<br/>    tenant              = optional(string, null)<br/>    environment         = optional(string, null)<br/>    stage               = optional(string, null)<br/>    name                = optional(string, null)<br/>    delimiter           = optional(string, null)<br/>    attributes          = optional(list(string), [])<br/>    tags                = optional(map(string), {})<br/>    label_order         = optional(list(string), null)<br/>    regex_replace_chars = optional(string, null)<br/>    id_length_limit     = optional(number, null)<br/>    label_key_case      = optional(string, null)<br/>    label_value_case    = optional(string, null)<br/>    labels_as_tags      = optional(set(string), null)<br/>    descriptor_formats = optional(map(object({<br/>      format = string<br/>      labels = list(string)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | <pre>map(object({<br/>    format = string<br/>    labels = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'. | `string` | `null` | no |
| <a name="input_http_method"></a> [http\_method](#input\_http\_method) | HTTP method (GET, POST, PUT, DELETE, ANY) | `string` | `"ANY"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` to keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>Note: The value of the `name` tag, if included, will be the `id`, not the `name`. | `set(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A customer identifier, indicating who this instance of a resource is for. | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_integration_uri"></a> [integration\_uri](#output\_integration\_uri) | Integration URI |
| <a name="output_method_http_method"></a> [method\_http\_method](#output\_method\_http\_method) | HTTP method of the created method |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | ID of the created API Gateway resource |
<!-- END_TF_DOCS -->
