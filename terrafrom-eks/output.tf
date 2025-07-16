output "eks_cluster_endpoint" {
  value = aws_eks_cluster.aws_eks.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.aws_eks.name
}
output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.aws_eks.certificate_authority
}
