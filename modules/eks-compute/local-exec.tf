# aws auth

resource "null_resource" "executor" {
  depends_on = ["aws_eks_cluster.cluster"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOS
while [ $? != 0 ]; do & \
echo "${null_resource.executor.triggers.aws_auth}" > aws_auth.yaml & \
echo "${null_resource.executor.triggers.kube_config}" > kube_config.yaml & \
kubectl apply -f aws_auth.yaml --kubeconfig kube_config.yaml & \
done & \
rm -rf aws_auth.yaml kube_config.yaml
EOS

    interpreter = var.local_exec_interpreter
  }

  triggers = {
    aws_auth    = "${data.template_file.aws_auth.rendered}"
    kube_config = "${data.template_file.kube_config.rendered}"
    endpoint    = "${aws_eks_cluster.cluster.endpoint}"
  }
}
