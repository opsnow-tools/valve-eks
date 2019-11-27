# variable

variable "root_domain" {
  description = "Root domain address, e.g: opsnow.io"
}

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

variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}

variable "public_subnet_ids" {
  description = "List of Public Subnet Ids"
  type        = "list"
  default     = []
}

variable "worker_sg_id" {
  description = "EKS worker security group. e.g. sg-xxxxxx"
  type        = "string"
  default     = ""
}

variable "weighted_routing" {
  description = "weighted_routing_policy aws_route53_record.address"
  default     = 100
}
variable "target_group_arn" {
  default = ""
}