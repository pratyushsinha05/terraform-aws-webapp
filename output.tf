output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The ID of the public_subnets"
  value       = module.vpc.public_subnet_ids
}