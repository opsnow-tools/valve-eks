# local file

data "aws_caller_identity" "current" {
}


locals {
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.upper_name}-BASTION"
      username = "iam-bastion"
      group    = "system:masters"
    },
    {
      rolearn  = ""
      username = "iam-coruscant"
      group    = "system:masters"
    },
  ]
}

variable "map_users" {
  default = [
    {
      user     = "user/sample"
      username = "sample"
      group    = "system:masters"
    },
  ]
}

data "template_file" "kube_config" {
  template = file("${path.module}/template/kube_config.yaml.tpl")

  vars = {
    CERTIFICATE     = aws_eks_cluster.cluster.certificate_authority[0].data
    MASTER_ENDPOINT = aws_eks_cluster.cluster.endpoint
    CLUSTER_NAME    = local.cluster_name
  }
}

data "template_file" "kube_config_secret" {
  template = file("${path.module}/template/kube_config_secret.yaml.tpl")

  vars = {
    CLUSTER_NAME = local.cluster_name
    ENCODED_TEXT = base64encode(data.template_file.kube_config.rendered)
  }
}

data "template_file" "aws_auth_map_roles" {
  count    = length(local.map_roles)
  template = file("${path.module}/template/aws_auth_map_roles.yaml.tpl")

  vars = {
    rolearn  = local.map_roles[count.index]["rolearn"]
    username = local.map_roles[count.index]["username"]
    group    = local.map_roles[count.index]["group"]
  }
}

data "template_file" "aws_auth_map_users" {
  count    = length(var.map_users)
  template = file("${path.module}/template/aws_auth_map_users.yaml.tpl")

  vars = {
    userid   = data.aws_caller_identity.current.account_id
    user     = var.map_users[count.index]["user"]
    username = var.map_users[count.index]["username"]
    group    = var.map_users[count.index]["group"]
  }
}

data "template_file" "aws_auth" {
  template = file("${path.module}/template/aws_auth.yaml.tpl")

  vars = {
    rolearn   = aws_iam_role.worker.arn
    map_roles = join("", data.template_file.aws_auth_map_roles.*.rendered)
    map_users = join("", data.template_file.aws_auth_map_users.*.rendered)
  }
}

resource "local_file" "aws_auth" {
  content  = data.template_file.aws_auth.rendered
  filename = "${path.cwd}/.output/aws_auth.yaml"
}

resource "local_file" "kube_config" {
  content  = data.template_file.kube_config.rendered
  filename = "${path.cwd}/.output/kube_config.yaml"
}

resource "local_file" "kube_config_secret" {
  content  = data.template_file.kube_config_secret.rendered
  filename = "${path.cwd}/.output/kube_config_secret.yaml"
}

resource "null_resource" "executor" {
  depends_on = [aws_eks_cluster.cluster]

  provisioner "local-exec" {
    working_dir = path.module

    command = <<EOS
echo "${null_resource.executor.triggers.aws_auth}" > aws_auth.yaml & \
echo "${null_resource.executor.triggers.kube_config}" > kube_config.yaml & \
for i in `seq 1 10`; do \
  kubectl apply -f aws_auth.yaml --kubeconfig kube_config.yaml && break || sleep 10; \
done; \
rm -rf aws_auth.yaml kube_config.yaml
EOS

    interpreter = ["/bin/sh", "-c"]
  }

  triggers = {
    aws_auth = data.template_file.aws_auth.rendered
    kube_config = data.template_file.kube_config.rendered
    endpoint = aws_eks_cluster.cluster.endpoint
  }
}
