output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}



output "ecr_arn" {
  description = "ECR ARN"
  value       = aws_ecr_repository.timestamp-ecr-repo.arn
}

output "ecr_registry_id" {
  description = "ECR Registry ID"
  value       = aws_ecr_repository.timestamp-ecr-repo.registry_id
}


output "ecr_registry_url" {
  description = "ECR Registry URL"
  value       = aws_ecr_repository.timestamp-ecr-repo.repository_url
}

