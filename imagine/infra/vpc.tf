
module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  ipv4_primary_cidr_block = "172.16.0.0/16"
  ipv4_cidr_block_association_timeouts = {
    create = "3m"
    delete = "5m"
  }

  assign_generated_ipv6_cidr_block = true

  default_security_group_deny_all       = var.default_security_group_deny_all
  default_route_table_no_routes         = var.default_route_table_no_routes
  default_network_acl_deny_all          = var.default_network_acl_deny_all
  network_address_usage_metrics_enabled = var.network_address_usage_metrics_enabled
  context                               = module.label.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.0.4"

  availability_zones   = data.aws_availability_zones.current.names
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.label.context
}

# Verify that a disabled VPC generates a plan without errors
module "vpc_disabled" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  enabled = false

  ipv4_primary_cidr_block          = "172.16.0.0/16"
  assign_generated_ipv6_cidr_block = true

  context = module.label.context
}
