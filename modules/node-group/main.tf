resource "aws_iam_role" "worker_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ]
  })
  description = "EKS node role for ${var.env} env"
  name        = "EKS-node-role-${var.env}-env"
  path        = "/"
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "worker_node_policy_to_role" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy_to_role" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cni_policy_to_role" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_eks_node_group" "node_group" {
  cluster_name  = var.cluster_name
  node_role_arn = aws_iam_role.worker_role.arn
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  subnet_ids      = var.private_subnets_ids
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  node_group_name = "node-group-${var.env}-env"
  tags            = var.tags
  depends_on = [
    aws_iam_role_policy_attachment.cni_policy_to_role,
    aws_iam_role_policy_attachment.worker_node_policy_to_role,
    aws_iam_role_policy_attachment.ecr_policy_to_role
  ]
}
