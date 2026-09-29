output "vpc_id" {
  description = "ID of the platform VPC"
  value       = aws_vpc.platform.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "ecr_repository_url" {
  description = "ECR repository URL for the production AI image"
  value       = aws_ecr_repository.platform.repository_url
}
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.platform.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS control plane"
  value       = aws_eks_cluster.platform.endpoint
}