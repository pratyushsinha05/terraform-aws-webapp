output "vpc_id" {
  description = "The ID of the created security group"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}