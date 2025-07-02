output "cluster_endpoint" {
  value = aws_eks_cluster.nextshop_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.nextshop_cluster.name
}
