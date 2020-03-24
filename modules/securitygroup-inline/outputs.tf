
output "sg_id" {
  value = "${aws_security_group.node-ingress.id}"
}
output "svc_sg_id" {
  value = "${aws_security_group.service.id}"
}