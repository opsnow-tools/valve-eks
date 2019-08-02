# main

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = ""
    key    = "" #okc0.tfstate
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "valve" {
  source = "./modules"

  # common value
  region = "ap-northeast-2"
  city = ""
  stage = ""
  name = ""

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
