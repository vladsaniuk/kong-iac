resource "aws_eks_addon" "kube_proxy" {
  addon_name                  = "kube-proxy"
  cluster_name                = var.cluster_name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags                        = tomap(merge({ Name = "kube-proxy-add-on-${var.env}-env" }, var.tags))
  preserve                    = false
}

resource "aws_eks_addon" "coredns" {
  addon_name                  = "coredns"
  cluster_name                = var.cluster_name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags                        = tomap(merge({ Name = "CoreDNS-add-on-${var.env}-env" }, var.tags))
  preserve                    = false
}

resource "aws_eks_addon" "amazon_vpc_cni" {
  addon_name                  = "vpc-cni"
  cluster_name                = var.cluster_name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags                        = tomap(merge({ Name = "Amazon-VPC-CNI-add-on-${var.env}-env" }, var.tags))
  preserve                    = false
}
