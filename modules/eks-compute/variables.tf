# variable

variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
}

variable "city" {
  description = "City Name of the cluster, e.g: VIRGINIA"
}

variable "stage" {
  description = "Stage Name of the cluster, e.g: DEV"
}

variable "name" {
  description = "Name of the cluster, e.g: DEMO"
}

variable "suffix" {
  description = "Name of the cluster, e.g: EKS"
}

variable "kubernetes_version" {
  default = "1.12"
}

variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}

variable "subnet_ids" {
  description = "List of Subnet Ids"
  type        = "list"
  default     = []
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