# variable

## Security Group
variable "sg_name" {
  description = "Name of the Security Group, e.g: node"
}

variable "sg_desc" {
  description = "Description of the Security Group"
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

variable "is_self" {
  description = "If true, the security group itself will be added as a source to this ingress rule."
}

variable "source_sg_ids" {
  description = "source security group ids"
  # type        = "tuple"
  default     = []
}

variable "source_sg_cidrs" {
  description = "source cidrs"
  # type        = "tuple"
  default     = []
}

variable "allow_ip_address" {
  description = "List of IP Address to permit access"
  type        = "list"
  default     = ["*"]
}
