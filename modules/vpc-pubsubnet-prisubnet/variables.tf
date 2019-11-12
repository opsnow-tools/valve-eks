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

variable "vpc_id" {
  description = "The VPC ID."
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "public_subnet_enable" {
  default = true
}

variable "public_subnet_count" {
  default = 0
}

variable "public_subnet_zones" {
  type    = list(string)
  default = []
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "public_subnet_newbits" {
  default = 4
}

variable "public_subnet_netnum" {
  default = 0
}

variable "private_subnet_enable" {
  default = true
}

variable "private_subnet_count" {
  default = 0
}

variable "private_subnet_zones" {
  type    = list(string)
  default = []
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "private_subnet_newbits" {
  default = 2
}

variable "private_subnet_netnum" {
  default = 1
}

variable "single_nat_gateway" {
  default = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
