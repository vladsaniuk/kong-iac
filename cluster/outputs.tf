output "eks_oidc" {
  value = module.eks.eks_oidc
}

output "node_group" {
  value = module.node_group.node_group
}
