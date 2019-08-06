# main

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = ""
    key    = ""
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
  stage = "DEV"
  name = "TEST"
}

# output
  
output "vpc_id" {
  value = module.valve.vpc_id
}

output "vpc_cidr" {
  value = module.valve.vpc_cidr
}

output "subnet_id" {
  value = module.valve.subnet_id
}

output "efs_id" {
  value = module.valve.efs_id
}

output "config" {
  value = module.valve.config
}
