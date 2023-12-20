variable "azs" {
  description = "The specific Availability Zones to use for our VPC"
  type        = list
  default     = []
}

variable "cidr" {
  description = "The CIDR of the VPC"
  type        = string
  default     = "10.43.12.0/22"
}

data "aws_availability_zones" "available" {}

locals {
  cidr		      = var.cidr
  azs                 = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, 4)
  ipv4_step           = length(local.azs) > 3 ? 2 : 1 # The more subnets we have the more room we'll need for our IP space
  private_subnets     = [for k, v in local.azs : cidrsubnet(var.cidr, 3, k)]
  public_subnet      = cidrsubnet(var.cidr, 3, local.ipv4_step + length(local.azs))
}

output "vpc_cidr" {
  description = "The content of private_subnets file"
  value       = local.cidr
}

output "private_subnets" {
  value       = local.private_subnets
}

output "public_subnet" {
  value  = local.public_subnet
}
