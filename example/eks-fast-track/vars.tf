# Security Group
variable "sg_name" {
  description = "Name of the Security Group, e.g: node"
}
variable "sg_desc" {
  description = "Description of the Security Group"
}
variable "aws_region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
}
variable "city" {
  description = "City Name of the cluster, e.g: VIRGINIA"
}
variable "stage" {
  description = "Stage Name of the cluster, e.g: DEV"
}
variable "cluster_name" {
  description = "Name of the cluster, e.g: DEMO"
}
variable "suffix" {
  description = "Name of the cluster, e.g: EKS"
}
variable "is_self" {
  description = "If true, the security group itself will be added as a source to this ingress rule."
  default     = false
}
variable "source_sg_cidrs" {
  description = "source cidrs"
  # type        = "tuple"
  default     = []
}
variable "vpc_cidr" {
}
# EKS Cluster
variable "kubernetes_version" {
  default = "1.12"
}
variable "launch_configuration_enable" {
  default = true
}
variable "associate_public_ip_address" {
  default = false
}
variable "instance_type" {
  default = "m4.large"
}
variable "mixed_instances" {
  type    = "list"
  default = []
}
variable "volume_type" {
  default = "gp2"
}
variable "volume_size" {
  default = "128"
}
variable "min" {
  default = "1"
}
variable "max" {
  default = "5"
}
variable "on_demand_base" {
  default = "1"
}
variable "on_demand_rate" {
  default = "30"
}
variable "key_name" {
  default = ""
}
variable "key_path" {
  default = ""
}
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type        = "list"
  default     = []
}
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"
  default     = []
}
variable "local_exec_interpreter" {
  description = "Command to run for local-exec resources. Must be a shell-style interpreter."
  type        = "list"
  default     = ["/bin/sh", "-c"]
}
variable "buckets" {
  type    = "list"
  default = []
}
variable "master_sg_id" {
  description = "EKS master security group. e.g. sg-xxxxxx"
  type        = "string"
  default     = ""
}
variable "worker_sg_id" {
  description = "EKS worker security group. e.g. sg-xxxxxx"
  type        = "string"
  default     = ""
}
variable "target_group_http_arn" {
  description = "Target group at ELB"
  type        = "string"
  default     = ""
}
variable "root_domain" {
  description = "Root domain address, e.g: opsnow.io"
}
variable "weighted_routing" {
  description = "weighted_routing_policy aws_route53_record.address"
  default     = 100
}
variable "public_subnet_cidrs" {
  type    = "list"
  default = []
}
variable "private_subnet_cidrs" {
  type    = "list"
  default = []
}
