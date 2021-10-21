# CLUSTER SECURITY GROUPS
module "cluster-sg" {
  source         = "terraform-aws-modules/security-group/aws"
  #version        = "~> 4.0.1"
  name           = "${var.sg-name}_cluster"
  vpc_id         = data.terraform_remote_state.backend_network.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 10000
      protocol                 = "tcp"
      description              = "Allow pods to communicate with the cluster API Server"
      source_security_group_id = module.node-sg.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name = "${var.cluster-name}-eks-cluster-sg"
  }
}

# NODES SECURITY GROUPS

module "node-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "~> 4.0.1"

  name        = "${var.sg-name}_node"

  vpc_id      = data.terraform_remote_state.backend_network.outputs.vpc_id

  ingress_cidr_blocks = [data.aws_vpc.eks.cidr_block]
  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 1025
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Allow EKS Control Plane"
      source_security_group_id = module.cluster-sg.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name                                        = "${var.cluster-name}-eks-node-sg"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

# BASTION
module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "~> .0.1"

  name        = "${var.sg-name}_Bastion"
  description = "Security group which is to allow SSH from Bastion"
  vpc_id      = data.terraform_remote_state.backend_network.outputs.vpc_id

  ingress_cidr_blocks = ["127.0.0.1/32"] #Change Here for your IP
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}