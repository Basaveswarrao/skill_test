# EKS Cluster Resources

resource "aws_eks_cluster" "eks" {
  name                       = var.cluster-name
  version                    = var.k8s-version
  role_arn                   = aws_iam_role.cluster.arn
  vpc_config {
    security_group_ids       = [data.aws_security_group.cluster.id]
    subnet_ids               = data.terraform_remote_state.backend_network.outputs.private_subnets
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}
