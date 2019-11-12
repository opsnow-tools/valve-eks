# local file

resource "local_file" "aws_auth" {
  content  = "${data.template_file.aws_auth.rendered}"
  filename = "${path.root}/.output/aws_auth.yaml"
}

resource "local_file" "kube_config" {
  content  = "${data.template_file.kube_config.rendered}"
  filename = "${path.root}/.output/kube_config.yaml"
}
