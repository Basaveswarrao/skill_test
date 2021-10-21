output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

resource "local_file" "kube_config" {
    content  = "${local.kubeconfig}"
    filename = "eks-cluster-config"
}
