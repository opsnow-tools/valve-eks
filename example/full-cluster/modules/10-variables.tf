# variable

variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1"
  default = "ap-northeast-2"
}

variable "city" {
  description = "City Name of the cluster, e.g: VIRGINIA"
  default = "SEOUL"
}

variable "stage" {
  description = "Stage Name of the cluster, e.g: DEV"
  default = "DEV"
}

variable "name" {
  description = "Name of the cluster, e.g: DEMO"
  default = "TEST"
}
