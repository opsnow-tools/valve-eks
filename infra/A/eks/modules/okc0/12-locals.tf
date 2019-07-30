# locals
data "aws_availability_zones" "azs" {
}

  
locals {
  name = "${var.stage}-${var.name}"

  full_name = "${var.city}-${var.stage}-${var.name}"

  /*
    ex) region_A_upper_name, region_B_upper_name, region_C_upper_name, ...
  */
  region_A_upper_name = upper("${var.city}-A-${var.stage}-${var.name}")

  region_C_upper_name = upper("${var.city}-C-${var.stage}-${var.name}")

  cluster_name = "${local.lower_name}-eks"

  upper_cluster_name = upper(local.cluster_name)

  elastic_name = "{local.lower_name}-elasticsearch"

  upper_elastic_name = upper(local.elastic_name)

  tags = map("kubernetes.io/cluster/${local.cluster_name}", "shared")

  upper_name = upper(local.full_name)

  lower_name = lower(local.full_name)

  az_names = data.aws_availability_zones.azs.names

  az_length = length(local.az_names[0])
}

locals {
  worker_tags = [
    {
      key                 = "Name"
      value               = "${local.upper_name}-EKS-WORKER"
      propagate_at_launch = true
    },
    {
      key                 = "KubernetesCluster"
      value               = "${local.cluster_name}"
      propagate_at_launch = true
    },
    {
      key                 = "kubernetes.io/cluster/${local.cluster_name}"
      value               = "owned"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster-autoscaler/enabled"
      value               = "true"
      propagate_at_launch = true
    },
  ]
}

locals {
  userdata = <<EOF
#!/bin/bash -xe
/etc/eks/bootstrap.sh \
  --enable-docker-bridge true \
  --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' \
  --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority[0].data}' \
  '${local.cluster_name}'
EOF

}

locals {
  config = <<EOF
#
# kube config
aws eks update-kubeconfig --name ${local.cluster_name} --alias ${local.cluster_name}
# or
mkdir -p ~/.kube && cp .output/kube_config.yaml ~/.kube/config
# files
cat .output/aws_auth.yaml
cat .output/kube_config.yaml
# get
kubectl get node -o wide
kubectl get all --all-namespaces
#
EOF

}
