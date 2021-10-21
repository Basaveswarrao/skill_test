data "terraform_remote_state" "backend_network" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    region = var.remote_state_region
    key = var.networking_remote_state_key
  }
}

data "aws_vpc" "eks" {
  id = data.terraform_remote_state.backend_network.outputs.vpc_id
}

data "aws_security_group" "cluster" {
  vpc_id = data.terraform_remote_state.backend_network.outputs.vpc_id
  name   = "${module.cluster-sg.security_group_name}"
}

data "aws_security_group" "node" {
  vpc_id = data.terraform_remote_state.backend_network.outputs.vpc_id
  name   = "${module.node-sg.security_group_name}"
}

data "aws_security_group" "bastion" {
  vpc_id = data.terraform_remote_state.backend_network.outputs.vpc_id
  name   = "${module.ssh_sg.security_group_name}"
}

data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
}


data "aws_ami" "grafana" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
}


data "aws_ami" "eks-worker-ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s-version}-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}