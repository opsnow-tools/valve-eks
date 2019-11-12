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

variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}

variable "subnet_ids" {
  description = "List of Subnet Ids"
  type        = "list"
  default     = []
}

variable "mount_target_sg" {
  description = "Security Group ID for mount target"
  type        = "list"
  default     = []
}