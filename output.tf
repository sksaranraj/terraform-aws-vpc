output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.vpc.id
}
output "private_subnets_id" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnets.*.id
}
output "public_subnets_id" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.public_subnets.*.id
}
