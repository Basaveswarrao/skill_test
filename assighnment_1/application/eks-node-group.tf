resource "aws_eks_node_group" "default-node-group" {
  cluster_name           = var.cluster-name
  node_group_name        = "${var.cluster-name}-node-group"
  node_role_arn          = aws_iam_role.node.arn
  subnet_ids             = data.terraform_remote_state.backend_network.outputs.private_subnets
  disk_size              = var.root-block-size
  capacity_type          = "SPOT"
  scaling_config {
    desired_size         = var.desired-capacity
    max_size             = var.max-size
    min_size             = var.min-size
  }
  instance_types = [
    var.node-instance-type
  ]
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]
  labels = var.default-labels
  tags = {
    Name = "${var.cluster-name}-test-node-pool-network-tag"
  }
}
