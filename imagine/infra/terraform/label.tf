module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  delimiter  = var.delimiter

  tags = {
    "ManagedBy"     = "Terraform",
    "ResourceOwner" = "valterh@amazon.com",
  }
}
