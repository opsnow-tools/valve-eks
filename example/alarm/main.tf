# main

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "valve-eks-example"
    key    = "alertnow-integration.tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "valve" {
  source = "./modules"

  # common value
  region = "ap-northeast-2"
  city = "SEOUL"
  stage = "SRE"
  name = "MIXED"
}
